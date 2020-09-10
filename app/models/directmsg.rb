class Directmsg < ApplicationRecord
  validates :name, presence: true
  
  has_many :users_directmsgs
  has_many :users, through: :users_directmsgs
end
