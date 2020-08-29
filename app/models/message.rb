class Message < ApplicationRecord
  validates :content, presence: true
  belongs_to :user
  belongs_to :channel
end
