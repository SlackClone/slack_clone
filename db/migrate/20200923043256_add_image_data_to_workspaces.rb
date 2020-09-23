class AddImageDataToWorkspaces < ActiveRecord::Migration[6.0]
  def change
    add_column :workspaces, :image_data, :text
  end
end
