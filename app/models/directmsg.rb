class Directmsg < ApplicationRecord
  validates :name, presence: true
  
  has_many :messages, as: :messageable, dependent: :destroy
  
  has_many :users_directmsgs, dependent: :destroy
  has_many :users, through: :users_directmsgs
  has_many :messages, as: :messageable
  has_many :mentions, as: :messageable

  belongs_to :workspace


  def self.create_or_find(users, workspace_id)
    users_ids = users.map(&:id).sort
    name = "DM:#{users_ids.join("-")}"
    if directmsg = self.where(name: name).first
      directmsg
    else
      # create a new directmsg
      directmsg = new(name: name, workspace_id: workspace_id)
      directmsg.users = users
      directmsg.save
      directmsg
    end
  end

end
