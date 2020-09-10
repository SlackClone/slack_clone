class CreateUsersDirectmsgs < ActiveRecord::Migration[6.0]
  def change
    create_table :users_directmsgs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :directmsg, null: false, foreign_key: true

      t.timestamps
    end
  end
end
