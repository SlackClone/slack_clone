class RenameMessageIdToShareMessageId < ActiveRecord::Migration[6.0]
  def change
     add_column :messages, :share_message_id, :integer, index: true
  end
end
