class AddWorkspaceToDirectmsgs < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_reference :directmsgs, :workspace, null: false, index: {algorithm: :concurrently}
  end
end
