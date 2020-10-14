class UsersDirectmsg < ApplicationRecord
  belongs_to :user
  belongs_to :directmsg

  before_destroy :destroy_directmsg, :abc

  def destroy_directmsg
    self.directmsg.destroy
  end
end