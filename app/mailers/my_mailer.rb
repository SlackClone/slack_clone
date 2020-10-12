class MyMailer < ApplicationMailer

  def invite(current_user,workspace,invitation)
    @invitation = invitation
    @user = current_user
    @workspace = workspace
    mail(to: @invitation.receiver_email, subject: I18n.t("mailer.title",username: @user.nickname))
  end
  
end