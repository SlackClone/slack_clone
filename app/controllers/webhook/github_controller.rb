class Webhook::GithubController < ActionController::API

  before_action :find_bot_id, :find_channel_id

  def payload
    # TODO: 從資料表撈出 secret
    github_secrets = ['c9cee6d85787e40ac9ff5384d57ccd4789e4394d', '44b0eb783b2ab91de6b870b9c276a0ed98edcada']
    # github_secrets = WebhookSecret.all => bad pratice

    # TODO: (optional): 幫使用者自動產生 secret
    # generate_github_secret = SecureRandom.hex(20) 

    # TODO (optional): rewind 是否必要？
    # 如果 contenet type 為 application/json 的話似乎才需要 request.body.rewind
    # request.body.rewind
    payload_body = request.body.read
    # byebug
    
    # 驗證 payload 是否為 github 發出
    github_secrets.each do |github_secret|  
      if signature?(payload_body, github_secret) 
        # 轉成 json 
        json_body = JSON.parse(params[:payload]) 
  
        # 取得 payload 部份資料
        user_event_action_type = json_body["hook"]["events"][0]
        user_repository_name = json_body["repository"]["name"]
        user_repository_url = json_body["repository"]["html_url"]
        
        # TODO: 發送訊息匯整 & 把 hash 轉成 json 格式
        payload_content = { user_event_action_type: user_event_action_type, 
                            user_repository_name: user_repository_name, 
                            user_repository_url: user_repository_url }.to_json
  
        # TODO: 發送訊息流程修正
        send_webhook_message(@catbot.id, payload_content)
  
        render json: { message: 'OK' }, status: :ok   
        break   
      end
    end
  end

  private
    def signature?(payload_body, github_secret)
      # TODO (opttional): how to implement error handling
      excepted_signature = "sha1=#{OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), github_secret, payload_body)}"
      Rack::Utils.secure_compare(excepted_signature, request.env['HTTP_X_HUB_SIGNATURE'])      
    end

    def find_bot_id
      @catbot = User.find_by(nickname: 'CatBot')
    end

    def find_channel_id
      # TODO: 從接收 payload 的路徑找到要發送的 channel_id    
      @channel = Channel.find(params[:id])
    end

    def send_webhook_message(bot_id, payload_content)
      @message = @channel.messages.new(user_id: bot_id, content: payload_content)
 
      if @message.save
        SendChannelMessageJob.perform_later(@message, @channel.id)
      else
        # TODO: false condition
      end
    end

    def webhook_message_params
      params.require(:message).permit(:content).merge(user: @catbot.id)
    end
end