class Mention < ApplicationRecord
  belongs_to :user
  belongs_to :messageable, :polymorphic => true
  belongs_to :message
end
