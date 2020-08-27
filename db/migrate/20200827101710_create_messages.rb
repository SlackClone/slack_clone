class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.text :content
      t.references :channel, null: false, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
