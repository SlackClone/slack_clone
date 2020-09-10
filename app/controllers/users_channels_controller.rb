class UsersChannelsController < ApplicationController
  before_action :find_channel
  def create
    @channel.users_channels.where(user_id: current_user.id).first_or_create
    respond_to do |format|
      format.json { render json: {} }
    end
  end
  
  def destroy
    @channel.users_channels.where(user_id: current_user.id).destroy_all
    respond_to do |format|
      format.json { render json: {} }
    end
  end

  private
  def find_channel
    @channel = Channel.find(params[:channel_id])
  end

end