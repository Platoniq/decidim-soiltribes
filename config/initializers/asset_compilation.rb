# config/initializers/asset_compilation.rb
if ENV["RAILS_GROUPS"] == "assets" || ENV["RAILS_ENV"] == "production"
  # Prevent ActiveRecord from establishing a database connection
  Rails.application.config.active_record.database_selector = { delay: 0 }
  Rails.application.config.active_record.database_resolver = nil

  # Disable Deface overrides by overriding load_all
  if defined?(Deface)
    module Deface
      module Environment
        def load_all
          return if ENV["DISABLE_DEFACE"] == "true" || ENV["RAILS_GROUPS"] == "assets"
          super
        end
      end
    end
  end
end
