class Message < ApplicationRecord
  validates :content, presence: true
  
  belongs_to :user
  belongs_to :share_message, class_name: "Message", optional: true
  belongs_to :messageable, :polymorphic => true
end