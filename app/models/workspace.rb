class Workspace < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :channels, dependent: :destroy
  has_many :users_workspaces
  has_many :users, through: :users_workspaces
  has_many :invitations, dependent: :destroy
  has_many :directmsgs, dependent: :destroy
  include ImageUploader::Attachment(:image) # adds an `image` virtual attribute
end
