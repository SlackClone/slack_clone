class Message < ApplicationRecord
  validates :content, presence: true
  
  belongs_to :user
  belongs_to :share_message, class_name: "Message", optional: true
  belongs_to :messageable, :polymorphic => true
  
  has_many :message_files
  has_many :attachfiles, through: :message_files
  accepts_nested_attributes_for :attachfiles, allow_destroy: true
end