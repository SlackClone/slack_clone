require "shrine"
require "shrine/storage/file_system"
require "shrine/storage/memory"
# require "shrine/storage/s3"


Shrine.storages = { 
  cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"), # temporary 
  store: Shrine::Storage::FileSystem.new("public", prefix: "uploads"),       # permanent 
}

Shrine.plugin :activerecord 
Shrine.plugin :cached_attachment_data # for retaining the cached file across form redisplays 
Shrine.plugin :restore_cached_data # re-extract metadata when attaching a cached file 
Shrine.plugin :validation
Shrine.plugin :validation_helpers
Shrine.plugin :derivatives
Shrine.plugin :download_endpoint, prefix: "attachments"