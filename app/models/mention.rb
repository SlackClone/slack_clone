class Mention < ApplicationRecord
  validates :name, presence: true

  belongs_to :user
  belongs_to :message
  belongs_to :mentionable, :polymorphic => true
end
