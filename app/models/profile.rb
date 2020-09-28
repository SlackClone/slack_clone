class Profile < ApplicationRecord
  belongs_to :user
  include AvatarUploader::Attachment(:avatar) # adds an `image` virtual attribute
end
