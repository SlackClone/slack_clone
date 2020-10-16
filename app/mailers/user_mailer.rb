class UserMailer < Devise::Mailer  
  require 'mailgun-ruby'
  require 'digest/sha2'  
  helper  :application # helpers defined within `application_helper`
  include Devise::Controllers::UrlHelpers # eg. `confirmation_url`
  default template_path: 'devise/mailer'
  default "Message-ID"=>"#{Digest::SHA2.hexdigest(Time.now.to_i.to_s)}@sladock.tw"

  def confirmation_instructions(record, token, opts={})  
    # First, instantiate the Mailgun Client with your API key
    @resource = record
    @token = token
    @email = record["email"]
    if Rails.env.production?
      mg_client = Mailgun::Client.new(ENV["MAILGUN_API"])
      # Define your message parameters
      message_params =  { from: "sladock@sladock.tw",
                          to:   @email,
                          subject: I18n.t("devise.mailer.confirmation_instructions.subject"),
                          html: (render "./devise/mailer/confirmation_instructions")
                        }
      # Send your message through the client
      mg_client.send_message 'sladock.tw', message_params  
    else
      mail(to:@email,from: "sladock@sladock.tw",subject: I18n.t("devise.mailer.confirmation_instructions.subject"))
    end  
  end
end