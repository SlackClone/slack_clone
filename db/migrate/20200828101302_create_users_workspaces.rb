class CreateUsersWorkspaces < ActiveRecord::Migration[6.0]
  def change
    create_table :users_workspaces do |t|
      t.string :roll
      t.references :user, null: false, foreign_key: true
      t.references :workspace, null: false, foreign_key: true

      t.timestamps
    end
  end
end
