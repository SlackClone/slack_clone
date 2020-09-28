class Attachfile < ApplicationRecord
  include DocumentUploader::Attachment(:document)
  validates :document_data, presence: true
  belongs_to :message
end
