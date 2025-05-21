if ENV['RAILS_SKIP_DB_CONNECTION'] == 'true'
  puts "⚠️ RAILS_SKIP_DB_CONNECTION is set to true. Skipping database connection."
  
  # Patch ActiveRecord::Base to prevent database connections
  module ActiveRecord
    class Base
      class << self
        def connection
          # Return a mock connection that responds to common methods
          require 'ostruct'
          db_config = OpenStruct.new(adapter: 'nulldb')
          
          OpenStruct.new(
            pool: OpenStruct.new(db_config: db_config),
            schema_cache: OpenStruct.new(
              columns_hash: Hash.new { |h, k| h[k] = OpenStruct.new(name: k, type: :string) },
              primary_keys: Hash.new('id'),
              data_sources: []
            ),
            quote_table_name: ->(name) { name.to_s },
            quote_column_name: ->(name) { name.to_s },
            table_exists?: ->(*) { true },
            columns: ->(*) { [] },
            execute: ->(*) { [] },
            explain: ->(*) { "" }
          )
        end
        
        def columns_hash
          Hash.new { |h, k| h[k] = OpenStruct.new(name: k, type: :string) }
        end
        
        def load_schema!
          # Do nothing
        end
        
        def reset_column_information
          # Do nothing
        end
      end
    end
  end
  
  # Patch ActiveRecord::ConnectionAdapters to prevent connections
  module ActiveRecord
    module ConnectionAdapters
      class AbstractAdapter
        def self.new(*)
          # Return a dummy adapter that doesn't connect to DB
          require 'ostruct'
          OpenStruct.new(
            schema_cache: OpenStruct.new(
              columns_hash: Hash.new { |h, k| h[k] = OpenStruct.new(name: k, type: :string) },
              primary_keys: Hash.new('id'),
              data_sources: []
            ),
            quote_table_name: ->(name) { name.to_s },
            quote_column_name: ->(name) { name.to_s }
          )
        end
      end
    end
  end
end
