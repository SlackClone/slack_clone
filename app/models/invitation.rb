class Invitation < ApplicationRecord
  validates :receiver_email, presence: true
  validates :invitation_token, presence: true

  belongs_to :user
  belongs_to :workspace
end
