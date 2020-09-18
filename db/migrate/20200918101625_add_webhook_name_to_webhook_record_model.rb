class AddWebhookNameToWebhookRecordModel < ActiveRecord::Migration[6.0]
  def change
    add_column :webhook_records, :webhook_name, :string
  end
end
