class MyMailer < ApplicationMailer

  def invite(params)
    @invitation = params
    mail(to: @invitation.receiver_email, subject: I18n.t("mailer.title"))
  end

end