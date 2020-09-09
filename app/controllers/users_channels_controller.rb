class UsersChannelsController < ApplicationController
  before_action :find_channel
  def create
    @channel.users_channels.where(user_id: current_user.id).first_or_create
  end

  def destroy
    @channel.users_channels.where(user_id: current_user.id).destroy_all
  end

  private
  def find_channel
    @channel = Channel.find(params[:channel_id])
  end

end