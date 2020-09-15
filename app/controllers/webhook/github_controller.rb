class Webhook::GithubController < ActionController::API

  before_action :find_bot_id

  def payload
    # TODO: 從資料表撈出 secret
    github_secret = '44b0eb783b2ab91de6b870b9c276a0ed98edcada'

    # TODO: request.body.rewind, 需要查一下 rewind 的作用
    payload_body = request.body.read
    
    # 驗證 payload 是否為 github 發出
    signature?(payload_body, github_secret)
    
    # 轉成 json 
    json_body = JSON.parse(params[:payload])

    # 取得 payload 部份資料
    user_event_type = json_body["hook"]["events"]
    user_repository_name = json_body["repository"]["name"]
    user_repository_url = json_body["repository"]["html_url"]
    
    # TODO: 發送訊息匯整
    payload_content = json_body["repository"]["html_url"]

    # TODO: 發送訊息流程修正
    send_webhook_message(@catbot.id, payload_content)

    render json: { message: 'OK' }, status: :ok
  end

  private
    def signature?(payload_body, github_secret)
      excepted_signature = "sha1=#{OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), github_secret, payload_body)}"
      Rack::Utils.secure_compare(excepted_signature, request.env['HTTP_X_HUB_SIGNATURE'])      
    end

    def find_bot_id
      @catbot = User.find_by(nickname: 'CatBot')
    end

    def send_webhook_message(bot_id, payload_content)
      # TODO: 找到 secret 相對應的 channel_id
      @channel = Channel.first
      @message = @channel.messages.new(user_id: bot_id, content: payload_content)
      
      if @message.save
        # TODO: @channel.id 要改成 channel_id
        SendChannelMessageJob.perform_later(@message, @channel.id)
      end
    end

    def webhook_message_params
      params.require(:message).permit(:content).merge(user: @catbot.id)
    end
end