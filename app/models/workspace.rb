class Workspace < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :channels
  has_many :users_workspaces
  has_many :users, through: :users_workspaces
<<<<<<< HEAD
  has_many :invitations
=======
  has_many :directmsgs
>>>>>>> add directmsg path to message create
end
