class Channel < ApplicationRecord
  validates :name, presence: true, uniqueness: { scope: :workspace_id }
  validates :public, presence: true

  has_many :messages, as: :messageable, dependent: :destroy
  has_many :webhook_records

  has_many :users_channels, dependent: :destroy
  has_many :users, through: :users_channels
  
  belongs_to :workspace
end
