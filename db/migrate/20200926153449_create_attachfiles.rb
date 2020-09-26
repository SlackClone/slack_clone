class CreateAttachfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :attachfiles do |t|
      t.text :document_data, null: false
      t.references :message, null: false, foreign_key: true

      t.timestamps
    end
  end
end
