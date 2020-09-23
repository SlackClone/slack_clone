require "shrine"
require "shrine/storage/file_system"
require "shrine/storage/s3"
 # require "shrine/storage/s3"
 
s3_options = { 
  bucket: ENV["BUCKET"], # required 
  access_key_id: ENV["ACCESS_KEY_ID"],
  secret_access_key: ENV["SECRET_ACCESS_KEY"],
  region: ENV["REGION"],
}
 
Shrine.storages = { 
  cache: Shrine::Storage::S3.new(prefix: "cache", **s3_options),
  store: Shrine::Storage::S3.new(prefix: "store",**s3_options),
}

Shrine.plugin :activerecord           # loads Active Record integration
Shrine.plugin :cached_attachment_data # for retaining the cached file across form redisplays 
Shrine.plugin :restore_cached_data # re-extract metadata when attaching a cached file 
Shrine.plugin :validation
Shrine.plugin :validation_helpers
Shrine.plugin :derivatives
Shrine.plugin :download_endpoint, prefix: "attachments"
