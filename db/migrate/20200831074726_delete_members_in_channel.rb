class DeleteMembersInChannel < ActiveRecord::Migration[6.0]
  def change
    remove_column :channels, :members
  end
end
