class AddMentionColumnToMessage < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :mention_tag, :string, array: true, default: []
  end
end
