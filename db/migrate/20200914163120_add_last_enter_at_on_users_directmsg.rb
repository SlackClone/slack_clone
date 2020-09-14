class AddLastEnterAtOnUsersDirectmsg < ActiveRecord::Migration[6.0]
  def change
    add_column :users_directmsgs, :last_enter_at, :datetime
  end
end
