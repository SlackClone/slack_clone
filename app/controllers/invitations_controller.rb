class InvitationsController < ApplicationController
  before_action :authenticate_user!,only: [:create]
  before_action :find_workspace
  def create
    unless @workspace.users.find_by(email: invitation_params[:receiver_email])
      @invitation = Invitation.new(invitation_params)
      @invitation.assign_attributes(
        user: current_user,
        workspace: @workspace,
        invitation_token: Devise.friendly_token[0,20]
      )
      if @invitation.save
        MyMailer.invite(@invitation).deliver_now
        redirect_to request.referrer, notice: I18n.t("invitations.create",receiver: @invitation.receiver_email)
      end
    else 
      redirect_to request.referrer, notice: "已經在WS瞜"
    end
  end

  def accept
    session[:email] = find_receiver_email
    session[:workspace_id] = @workspace.id
    session[:token] = params[:token]
    cookies[:accept] = @workspace.id
    return redirect_to new_user_registration_path if !User.find_by(email: find_receiver_email)
    if find_invitation
    return redirect_to workspaces_path if @workspace.users.find_by(email: find_receiver_email)
      @workspace.users << User.find_by(email: find_receiver_email)
      find_invitation.touch(:accept_at)
      sign_in(User.find_by(email: find_receiver_email))
      redirect_to workspace_path(@workspace),notice: I18n.t("invitations.accept",new_member: find_receiver_email)
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
    Invitation.find_by(invitation_token: params[:token]).try(:receiver_email)
  end

  def find_invitation
    Invitation.find_by(invitation_token: params[:token]) if params[:token]
  end
end
