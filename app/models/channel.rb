class Channel < ApplicationRecord
  has_many :messages
  belongs_to :workspace
end
