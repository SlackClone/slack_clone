class WebhookRecord < ApplicationRecord
  belongs_to :user
  belongs_to :channel

  validates :webhook_name, uniqueness: true
  validates :repo_name, presence: true, uniqueness: true
  validates :secret, presence: true, uniqueness: true
  validates :payload_url, presence: true
end
