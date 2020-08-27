class Workspace < ApplicationRecord
  validates :name, presence: true

  has_many :channels
end
