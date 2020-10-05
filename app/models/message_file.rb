class MessageFile < ApplicationRecord
  belongs_to :message
  belongs_to :attachfile
end
