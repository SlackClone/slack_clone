class Webhook::GithubController < ActionController::API

  def payload
    # 測試用的 secrets
    # https://d05eb2c02897.ngrok.io/webhooks
    # github_secrets = [44b0eb783b2ab91de6b870b9c276a0ed98edcada]

    # TODO: 幫使用者自動產生 secret => webhooks_controller => new/edit page
    # generate_github_secret = SecureRandom.hex(20) 

    # Get repository name from incoming payload
    json_body = JSON.parse(params[:payload])
    user_repository_name = json_body["repository"]["full_name"]
    
    # find reposity name form model
    if check_repo_name_exist?(user_repository_name)
      # 從資料表撈出 secret
      github_secret = @search_repo_result.secret
      
      # 讀 payload 資料
      payload_body = request.body.read

      # 驗證 payload
      if signature?(payload_body, github_secret) 
        # byebug
        if json_body["hook"]
          user_event_action_type = "Test webhook"
          # user_event_action_type = json_body["hook"]["events"][0] 
        elsif json_body["head_commit"]["message"]
          user_event_action_type = json_body["head_commit"]["message"]
          pusher = json_body["head_commit"]["author"]["name"]
        elsif json_body["commits"][0]["message"]
          user_event_action_type = json_body["commits"][0]["message"]
        else
          user_event_action_type = "No Commit Message"
        end

        pusher = json_body["pusher"]["name"]
        
        user_repository_url = json_body["repository"]["html_url"]
        payload_content = "<p>Pusher: <span class=\"text-teal-700\">#{pusher}</span></p>
                           <p>Commit Message: <span class=\"text-red-700\">#{user_event_action_type}</span></p>
                           <p>Repository: <span>#{user_repository_name}</span></p>
                           <p>Repository URL: <a href=\"#{user_repository_url}\" class=\"text-blue-700\">#{user_repository_url}</a></p>"


        # 找到 channel id & 發送訊息
        find_bot_id
        find_channel_id
        send_webhook_message(@catbot.id, payload_content)

        render json: { message: 'OK' }, status: :ok  
      end
  end
end

  private
    def signature?(payload_body, github_secret)
      # TODO (opttional): how to implement error handling
      excepted_signature = "sha1=#{OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), github_secret, payload_body)}"
      Rack::Utils.secure_compare(excepted_signature, request.env['HTTP_X_HUB_SIGNATURE'])      
    end

    def check_repo_name_exist?(user_repository_name)
      @search_repo_result = WebhookRecord.find_by(repo_name: user_repository_name)
    end

    def find_bot_id
      @catbot = User.find_by(nickname: 'CatBot')
    end

    def find_channel_id
      # 從接收 payload endpoint 的路徑中，抓到要發送的 channel_id    
      @channel = Channel.find(params[:id])
    end

    def send_webhook_message(bot_id, payload_content)
      @message = @channel.messages.new(user_id: bot_id, content: payload_content)
      @bot_avatar_url = @catbot.profile.try(:avatar_url,(:small))
 
      if @message.save
        SendMessageJob.perform_later(@message, @channel.id, @bot_avatar_url, false)
      else
        # TODO: false condition
      end
    end

    def webhook_message_params
      params.require(:message).permit(:content).merge(user: @catbot.id)
    end
end