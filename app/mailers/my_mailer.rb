class MyMailer < ApplicationMailer

  def invite(params)
    @invitation = params
    mail(to: @invitation.receiver_email, subject: "me invite into workspace")
  end

end