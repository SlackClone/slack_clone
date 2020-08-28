class CreateChannels < ActiveRecord::Migration[6.0]
  def change
    create_table :channels do |t|
      t.string :name
      t.text :topic
      t.boolean :public
      t.text :description
      t.integer :members
      t.references :workspace, null: false, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
