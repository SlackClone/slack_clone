class Workspace < ApplicationRecord
  include ImageUploader::Attachment(:image) # adds an `image` virtual attribute
  
  validates :name, presence: true, uniqueness: true

  has_many :channels, dependent: :destroy
  has_many :invitations, dependent: :destroy
  has_many :directmsgs, dependent: :destroy

  has_many :users_workspaces, dependent: :destroy
  has_many :users, through: :users_workspaces
end
