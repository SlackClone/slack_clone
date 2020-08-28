class Channel < ApplicationRecord
  validates :name, presence: true
  validates :topic, presence: true
  validates :public, presence: true
  validates :description, presence: true
  validates :members, presence: true

  has_many :messages
  belongs_to :workspace
end
