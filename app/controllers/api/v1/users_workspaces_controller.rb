class Api::V1::UsersWorkspacesController < ApplicationController
  def index
    @users = User.all
  end
end