# frozen_string_literal: true

# Staging shares production's S3 bucket, and once it runs on a copy of the
# production database its attachments point at production's real files. With
# DISABLE_STORAGE_DELETES set, Active Storage keeps the object whenever it is
# asked to delete one (a purged blob, a replaced avatar, removed variants) and
# only logs the key, so nothing done on staging can delete production's files.
# Uploads still work: new blobs get fresh keys and never overwrite existing
# objects. Never set it in production.
module StorageDeleteGuard
  def delete(key)
    Rails.logger.info("[storage guard] kept #{key}: DISABLE_STORAGE_DELETES is set")
  end

  def delete_prefixed(prefix)
    Rails.logger.info("[storage guard] kept #{prefix}*: DISABLE_STORAGE_DELETES is set")
  end
end

if ENV["DISABLE_STORAGE_DELETES"].present?
  Rails.application.config.after_initialize do
    require "active_storage/service/s3_service"
    require "active_storage/service/disk_service"

    ActiveStorage::Service::S3Service.prepend(StorageDeleteGuard)
    ActiveStorage::Service::DiskService.prepend(StorageDeleteGuard)
  end
end
