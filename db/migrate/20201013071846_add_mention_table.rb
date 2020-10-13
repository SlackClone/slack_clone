class AddMentionTable < ActiveRecord::Migration[6.0]
  def change
    create_table :mentions do |t|
      t.string :name, null: false
      t.references :user, null: false, foreign_key: true
      t.references :message, null: false, foreign_key: true
      t.references :mentionable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
