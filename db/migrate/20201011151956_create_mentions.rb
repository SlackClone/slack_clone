class CreateMentions < ActiveRecord::Migration[6.0]
  def change
    create_table :mentions do |t|
      t.string :name, null: false
      t.references :user, null: false, foreign_key: true
      t.references :messageable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
