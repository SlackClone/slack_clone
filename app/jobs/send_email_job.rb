class SendEmailJob < ApplicationJob
  queue_as :default

  def perform(current_user,workspace,invitation)
    MyMailer.invite(current_user,workspace,invitation).deliver_now
  end
end
