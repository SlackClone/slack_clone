class AddAttachfileAssociation < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!
  def change
    add_reference :attachfiles, :workspace, index: {algorithm: :concurrently}
  end
end
