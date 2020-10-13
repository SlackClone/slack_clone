class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # 新增 omniauthable第三方的module
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable,:validatable,:confirmable,
         :omniauthable, omniauth_providers: [:google_oauth2]
         
  validates :nickname, presence: true,length: { in: 2..8 }

  has_many :messages, dependent: :destroy
  has_many :invitations, dependent: :destroy
  has_one :profile, dependent: :destroy
  has_many :webhook_records, dependent: :destroy
  
  has_many :users_workspaces, dependent: :destroy
  has_many :workspaces, through: :users_workspaces
  
  has_many :users_channels, dependent: :destroy
  has_many :channels, through: :users_channels
  
  has_many :users_directmsgs, dependent: :destroy
  has_many :directmsgs, through: :users_directmsgs
  has_many :mentions, dependent: :destroy
  has_one :profile, dependent: :destroy
  has_many :webhook_records, dependent: :destroy

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.find_by(:google_token => access_token.credentials.token, :google_uid => access_token.uid )    
    return user if user.present?
    existing_user = User.find_by(:email => data["email"])
    if existing_user.present?
      existing_user.update(
        google_uid: access_token.uid,
        google_token: access_token.credentials.token
      )
      existing_user.skip_confirmation!
      existing_user.save
      existing_user
    else
      new_user = User.create(
        nickname: data["name"],
        email: data["email"],
        password: Devise.friendly_token[0,20],
        google_token: access_token.credentials.token,
        google_uid: access_token.uid
      )
      new_user.skip_confirmation!
      new_user.save
      new_user
    end
    
  end

  
end
