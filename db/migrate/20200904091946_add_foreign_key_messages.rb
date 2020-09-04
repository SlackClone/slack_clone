class AddForeignKeyMessages < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :messages, :users, validate: false
  end
end
