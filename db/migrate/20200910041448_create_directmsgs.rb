class CreateDirectmsgs < ActiveRecord::Migration[6.0]
  def change
    create_table :directmsgs do |t|
      t.string :name
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
