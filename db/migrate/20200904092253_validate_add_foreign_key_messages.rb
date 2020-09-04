class ValidateAddForeignKeyMessages < ActiveRecord::Migration[6.0]
  def change
    validate_foreign_key :messages, :users
  end
end
