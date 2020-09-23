class Workspace < ApplicationRecord
  include ImageUploader::Attachment(:image) # adds an `image` virtual attribute
  validates :name, presence: true, uniqueness: true

  has_many :channels
  has_many :users_workspaces
  has_many :users, through: :users_workspaces
  has_many :invitations
  has_many :directmsgs
end
