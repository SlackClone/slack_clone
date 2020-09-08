class Api::V1::UsersWorkspacesController < ApplicationController
  def index
   @user = User.all
  end
end