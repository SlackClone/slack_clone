class Message < ApplicationRecord
  validates :content, presence: true
  
  self.ignored_columns = ["channel_id"]
  belongs_to :user
  belongs_to :messageable, :polymorphic => true
end
