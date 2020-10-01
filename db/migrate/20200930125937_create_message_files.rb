class CreateMessageFiles < ActiveRecord::Migration[6.0]
  def change
    create_table :message_files do |t|
      t.references :message, null: false, foreign_key: true
      t.references :attachfile, null: false, foreign_key: true

      t.timestamps
    end
  end
end
