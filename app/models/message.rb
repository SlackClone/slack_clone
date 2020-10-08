class Message < ApplicationRecord
  validates :content, presence: true

  belongs_to :user
  belongs_to :share_message, class_name: "Message", optional: true
  belongs_to :messageable, :polymorphic => true
  
  has_many :message_files, dependent: :destroy
  has_many :attachfiles, through: :message_files
  accepts_nested_attributes_for :attachfiles, allow_destroy: true

  def toggle_emoji(emoji, user_id)
    if emoji_data[emoji].present?
      # someone cliked this emoji
      if emoji_data[emoji].include?(user_id)
        # user clicked thsi emoji , so delete it
        emoji_data[emoji].delete(user_id)
        if emoji_data[emoji].size.zero?
          emoji_data.delete(emoji)
        end
      else
        #使用者沒按過，把他加入
        emoji_data[emoji] << user_id
      end
    else
      emoji_data[emoji] = [user_id]
    end
    save
  end

end
