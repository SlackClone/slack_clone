class AddEmojidataToMessage < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :emoji_data, :jsonb, default: {}
  end
end
