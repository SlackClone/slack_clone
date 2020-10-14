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
        # MyMailer.invite(current_user,@workspace,@invitation).deliver_now
        SendEmailJob.perform_later(current_user,@workspace,@invitation)
        redirect_to request.referrer
      end
    else 
      redirect_to request.referrer
    end
  end

  def accept
    session[:email] = find_receiver_email
    session[:workspace_id] = @workspace.id
    session[:token] = params[:token]
    cookies[:workspace] = @workspace.id
    session[:channel] = @workspace.channels.find_by(name: "general").id

    return redirect_to new_user_registration_path if !find_user
    if find_invitation && find_general_channel.users.where.not(id: find_user)
      @workspace.users << find_user
      find_general_channel.users << find_user
      find_invitation.touch(:accept_at)
      sign_in(find_user)
      redirect_to workspace_channel_path(@workspace, find_general_channel),
        notice: I18n.t("invitations.accept",new_member: find_receiver_email)
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

  def find_general_channel
    @workspace.channels.find_by(name: "general")
  end

  def find_user
    User.find_by(email: find_receiver_email)
  end
end
