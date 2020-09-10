class Workspace < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :channels
  has_many :users_workspaces
  has_many :users, through: :users_workspaces
  has_many :invitations
end
