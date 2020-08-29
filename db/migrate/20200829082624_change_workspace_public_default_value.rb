class ChangeWorkspacePublicDefaultValue < ActiveRecord::Migration[6.0]
  def change
    change_column_default :channels, :public, to: true
  end
end
