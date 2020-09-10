class AddMessageableToMessages < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_reference :messages, :messageable, polymorphic: true, null: false, index: {algorithm: :concurrently}
  end
end
