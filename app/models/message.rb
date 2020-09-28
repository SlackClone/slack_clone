class Message < ApplicationRecord
  validates :content, presence: true
  
  belongs_to :user
  belongs_to :share_message, class_name: "Message", optional: true
  belongs_to :messageable, :polymorphic => true


def toggle_emoji(emoji,user_id)

  if emoji_data[emoji].present?
    # someone cliked this emoji
    if emoji_data[emoji].include?(user.id)
      # user clicked thsi emoji , so delete it
      emoji_data[emoji].delete(user.id)
      if emoji_data[emoji].size.zero?
        emoji_data[emoji] = nil
      end
    else
      #使用者沒按過，把他加入
      emoji_data[emoji] << user.id
    end
  else
    emoji_data[emoji] = [user.id]
  end
  save
end

end
