class Profile < ApplicationRecord
  include AvatarUploader::Attachment(:avatar) # adds an `image` virtual attribute
  
  belongs_to :user
end
