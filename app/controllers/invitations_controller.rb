class InvitationsController < ApplicationController
  before_action :authenticate_user!,:find_workspace
  def create
    @invitation = Invitation.new(invitation_params)
    @invitation.user = current_user
    @invitation.workspace = @workspace
    @invitation.invitation_token = Devise.friendly_token[0,20]
    if @invitation.save
    MyMailer.invite(@invitation).deliver_now
    redirect_to workspaces_path, notice: "邀請成功"
  else
    puts @invitation.errors.full_messages
    puts "something goes wrong"
    end
  end

  def accept
    if find_invitation_token && current_user.email == find_receiver_email
      if @workspace.users.find_by(email: find_receiver_email) == nil
        @workspace.users << User.find_by(email: find_receiver_email)
        find_invitation_token.touch(:accept_at)
        redirect_to @workspace,notice: "歡迎#{find_receiver_email}"
      end
    else
      redirect_to workspaces_path
    end
  end

private

  def invitation_params
    params.require(:invitation).permit(:receiver_email)
  end

  def find_workspace
    @workspace = Workspace.find(params[:workspace_id])
  end

  def find_receiver_email
    Invitation.find_by(invitation_token: params[:token]).receiver_email
  end

  def find_invitation_token
    Invitation.find_by(invitation_token: params[:token])
  end
end
