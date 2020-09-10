class CreateInvitations < ActiveRecord::Migration[6.0]
  def change
    create_table :invitations do |t|
      t.string :receiver_email
      t.string :invitation_token
      t.references :user, null: false, foreign_key: true
      t.references :workspace, null: false, foreign_key: true
      t.datetime :accept_at

      t.timestamps
    end
    add_index :invitations, :accept_at
  end
end
