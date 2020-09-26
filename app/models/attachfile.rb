class Attachfile < ApplicationRecord
  include DocumentUploader::Attachment(:document)
  
  belongs_to :message
end
