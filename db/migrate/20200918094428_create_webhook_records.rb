class CreateWebhookRecords < ActiveRecord::Migration[6.0]
  def change
    create_table :webhook_records do |t|
      t.string :repo_name
      t.string :secret
      t.string :payload_url
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :channel, null: false, foreign_key: true

      t.timestamps
    end
  end
end
