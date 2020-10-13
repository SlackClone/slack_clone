class DropMentionTable < ActiveRecord::Migration[6.0]
  def change
    drop_table :mentions
  end
end
