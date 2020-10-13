class Mention < ApplicationRecord
  validates :name, presence: true

  belongs_to :user
  belongs_to :message
  belongs_to :messageable, :polymorphic => true
end
