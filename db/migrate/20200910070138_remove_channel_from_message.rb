class RemoveChannelFromMessage < ActiveRecord::Migration[6.0]
  def change
    safety_assured { remove_reference :messages, :channel, index: true, foreign_key: true }
  end
end
