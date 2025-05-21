if ENV["RAILS_GROUPS"] == "assets" || ENV["RAILS_ENV"] == "production"
  # Prevent ActiveRecord from establishing a database connection
  Rails.application.config.active_record.database_selector = { delay: 0 }
  Rails.application.config.active_record.database_resolver = nil
  Deface::Override.active = false if defined?(Deface)
end
