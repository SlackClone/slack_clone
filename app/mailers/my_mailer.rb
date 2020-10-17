class MyMailer < ApplicationMailer
  require 'mailgun-ruby'
  require 'digest/sha2'  
  default "Message-ID"=>"#{Digest::SHA2.hexdigest(Time.now.to_i.to_s)}@sladock.tw"
  def invite(current_user,workspace,invitation)
    @invitation = invitation
    @user = current_user
    @workspace = workspace
    if Rails.env.production?
      # First, instantiate the Mailgun Client with your API key
      mg_client = Mailgun::Client.new(ENV["MAILGUN_API"])
      # Define your message parameters
      message_params =  { from: "sladock@sladock.tw",
                          to:   @invitation.receiver_email,
                          subject: I18n.t("mailer.title",username: @user.nickname),
                          html: (render "./my_mailer/invite")
                        }
      # Send your message through the client
      mg_client.send_message 'sladock.tw', message_params
    else
      mail(to:@invitation.receiver_email,subject: I18n.t("mailer.title",username: @user.nickname))
    end
  end
end