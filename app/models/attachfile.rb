class Attachfile < ApplicationRecord
  include DocumentUploader::Attachment(:document)
  validates :document_data, presence: true
  has_many :message_files, dependent: :destroy
  has_many :messages, through: :message_files
end
