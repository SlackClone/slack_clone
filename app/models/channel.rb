class Channel < ApplicationRecord
  validates :name, presence: true
  validates :public, presence: true
  validates :members, presence: true

  has_many :messages
  belongs_to :workspace
end
