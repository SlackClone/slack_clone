class ChangeColumnNameOfUsersWorkspaces < ActiveRecord::Migration[6.0]
  def change
    add_column :users_workspaces , :role, :string
    safety_assured { remove_column :users_workspaces, :roll }
  end
end
