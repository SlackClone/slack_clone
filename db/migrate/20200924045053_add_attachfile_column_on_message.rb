class AddAttachfileColumnOnMessage < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :document_data, :text
  end
end
