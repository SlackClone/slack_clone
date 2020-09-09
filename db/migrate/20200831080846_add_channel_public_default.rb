class AddChannelPublicDefault < ActiveRecord::Migration[6.0]
  def change
    change_column :channels, :public, :boolean, :default => true
  end
end