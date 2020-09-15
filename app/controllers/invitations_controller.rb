class InvitationsController < ApplicationController
  before_action :authenticate_user!,:find_workspace
  def create
    @invitation = Invitation.new(invitation_params)
    @invitation.assign_attributes(
      user: current_user,
      workspace: @workspace,
      invitation_token: Devise.friendly_token[0,20]
    )
    if @invitation.save
      MyMailer.invite(@invitation).deliver_now
      redirect_to workspaces_path, notice: I18n.t("invitations.create",receiver: @invitation.receiver_email)
    end
  end

  def accept
    if find_invitation && current_user.email == find_receiver_email
      unless @workspace.users.find_by(email: find_receiver_email)
        @workspace.users << User.find_by(email: find_receiver_email)
        find_invitation.touch(:accept_at)
        # sign_in user
        redirect_to @workspace,notice: I18n.t("invitations.accept",new_member: find_receiver_email)
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
    Invitation.find_by(invitation_token: params[:token]).try(:receiver_email)
  end

  def find_invitation
    Invitation.find_by(invitation_token: params[:token]) if params[:token]
  end
end
