class AddAncestryToMessage < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_column :messages, :ancestry, :string
    add_index :messages, :ancestry, algorithm: :concurrently
  end
end
