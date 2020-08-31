class Channel < ApplicationRecord
  validates :name, presence: true, uniqueness: { scope: :workspace_id }
  validates :public, presence: true

  has_many :messages
  belongs_to :workspace
end
