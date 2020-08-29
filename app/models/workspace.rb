class Workspace < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :channels
end
