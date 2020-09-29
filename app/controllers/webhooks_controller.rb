class WebhooksController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user_channels, only: [:new, :create, :edit, :update]
  before_action :back_to_workspace, only: [:index, :create]

  def index
    @webhooks = WebhookRecord.where(user: current_user.id)
  end

  def show
    @webhook = current_user.webhook_records.find(params[:id])
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
      # redirect_to workspace_channel_path(workspace_id: workspace, id: @webhook.channel_id)
      redirect_to webhooks_path, notice: 'Webhook has been created successfully'
    else
      render :new
    end

  end

  def edit
    @webhook = current_user.webhook_records.find(params[:id])
  end

  def update
    @webhook = current_user.webhook_records.find(params[:id])

    if @webhook.update(webhook_params)
      redirect_to webhooks_path, notice: 'Webhook has been updated successfully'
    else
      render :edit
    end
  end

  def destroy
    @webhook = current_user.webhook_records.find(params[:id])
    @webhook.destroy
    
    redirect_to webhooks_path, notice: 'Webhook has deleted.'
  end

  private
    def webhook_params
      params.require(:webhook_record).permit(:repo_name, :secret, :payload_url, :channel_id, :webhook_name).merge(user_id: current_user.id)
    end

    def find_user_channels
      current_workspace = session[:workspace_id]
      @user_channels = current_user.workspaces.find(current_workspace).channels
    end

    def back_to_workspace
       @back = {id: session[:channel_id], workspace_id: session[:workspace_id]}
    end

end
