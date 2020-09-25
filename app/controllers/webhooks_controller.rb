class WebhooksController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user_channels, only: [:new, :create, :edit]

  def index
    @webhooks = WebhookRecord.where(user: current_user.id)
  end

  def show
  end

  def new
    @webhook = WebhookRecord.new
  end

  def create
    @webhook = WebhookRecord.create(webhook_params)
    workspace = Channel.find(@webhook.channel_id).workspace

    if @webhook.save
      # 存入資料表後，導回到 webhook 設定的 channel 頁面 
      # 導回時，route 需要 workspace_id 與 channel_id
      redirect_to workspace_channel_path(workspace_id: workspace, id: @webhook.channel_id)
    else
      render :new
    end

  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
    def webhook_params
      params.require(:webhook_record).permit(:repo_name, :secret, :payload_url, :channel_id, :webhook_name).merge(user_id: current_user.id)
    end

    def find_user_channels
      @user_channels = current_user.channels
    end

end
