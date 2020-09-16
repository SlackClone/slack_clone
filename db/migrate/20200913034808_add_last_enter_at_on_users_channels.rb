class AddLastEnterAtOnUsersChannels < ActiveRecord::Migration[6.0]
  def change
    add_column :users_channels, :last_enter_at, :datetime
  end
end
