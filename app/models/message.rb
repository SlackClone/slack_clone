class Message < ApplicationRecord
  validates :content, presence: true
  
  belongs_to :user
  belongs_to :message, optional: true
  belongs_to :messageable, :polymorphic => true
end