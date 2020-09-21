class RemoveMessageIdFromMessage < ActiveRecord::Migration[6.0]
  def change
    safety_assured { remove_column :messages, :message_id }
  end
end
