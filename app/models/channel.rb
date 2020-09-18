class Channel < ApplicationRecord
  validates :name, presence: true, uniqueness: { scope: :workspace_id }
  validates :public, presence: true

  has_many :messages
  has_many :users_channels
  has_many :users, through: :users_channels
  has_many :messages, as: :messageable
  has_many :webhook_records
  belongs_to :workspace
end
