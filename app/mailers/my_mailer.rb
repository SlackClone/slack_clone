class MyMailer < ApplicationMailer

  def invite(current_user,workspace,invitation)
    require 'mailgun-ruby'
    require 'digest/sha2'  
    
    def invite(current_user,workspace,invitation)
      default "Message-ID"=>"#{Digest::SHA2.hexdigest(Time.now.to_i.to_s)}@sladock.tw"
      @invitation = invitation
      @user = current_user
      @workspace = workspace
      # First, instantiate the Mailgun Client with your API key
      mg_client = Mailgun::Client.new ENV["MAILGUN_API"]
      # Define your message parameters
      message_params =  { from: "sladock@sladock.tw",
                          to:   @invitation.receiver_email,
                          subject: I18n.t("mailer.title",username: @user.nickname),
                          html: (render "./my_mailer/invite.html.erb")
                        }
      # Send your message through the client
      mg_client.send_message 'sladock.tw', message_params  
    end
  end
end