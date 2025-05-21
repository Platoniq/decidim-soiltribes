if ENV['RAILS_SKIP_DB_CONNECTION'] == 'true'
  puts "⚠️ RAILS_SKIP_DB_CONNECTION is set to true. Skipping database connection."
  
  require 'ostruct'
  
  # Use a more thorough approach - intercept the database configuration entirely
  module ActiveRecord
    class Base
      class << self
        def connection
          # Create a result that responds to ALL common methods
          mock_result = Class.new do
            def initialize
              @rows = []
              @columns = []
            end
            
            def rows
              @rows
            end
            
            def columns
              @columns
            end
            
            def column_types
              {}
            end
          end.new
          
          # Return an object that responds to all common connection methods
          mock_conn = Object.new
          
          # Define methods dynamically to avoid missing method errors
          def mock_conn.method_missing(method_name, *args, &block)
            # For methods that query data and return resultsets
            if [:select_all, :select_one, :select_value, :select_values, 
                :execute, :exec_query, :query].include?(method_name)
              # Create empty result set
              Class.new do
                def rows
                  []
                end
                
                def columns
                  []
                end
                
                def column_types
                  {}
                end
                
                def each
                  # Empty enumerable
                end
                
                def to_a
                  []
                end
                
                def first
                  nil
                end
              end.new
            elsif [:insert, :update, :delete].include?(method_name)
              0 # Return zero affected rows
            elsif method_name == :transaction
              # Execute the block if given
              yield if block_given?
            elsif method_name == :table_exists?
              true
            elsif method_name == :columns
              []
            elsif method_name == :column_definitions
              []
            elsif method_name == :schema_cache
              OpenStruct.new(
                columns_hash: Hash.new { |h, k| h[k] = OpenStruct.new(name: k, type: :string) },
                primary_keys: Hash.new('id'),
                data_sources: [],
                columns: Hash.new([])
              )
            elsif method_name == :pool
              OpenStruct.new(
                db_config: OpenStruct.new(adapter: 'nulldb'),
                connection_class: ActiveRecord::Base
              )
            elsif method_name == :quote_table_name || method_name == :quote_column_name
              args.first.to_s
            else
              # Default behavior for other methods
              nil
            end
          end
          
          # Always return our mock for all connection requests
          mock_conn
        end
        
        # Additional overrides for other common AR methods
        def establish_connection(*args)
          # Don't actually establish a connection
        end
        
        def connected?
          true # Pretend we're connected
        end
        
        def retrieve_connection
          connection # Return our mock connection
        end
        
        def columns_hash
          Hash.new { |h, k| h[k] = OpenStruct.new(name: k, type: :string) }
        end
        
        def load_schema!
          # No-op, don't load schema
        end
        
        def reset_column_information
          # No-op
        end
      end
    end
  end
  
  # Patch ActiveRecord::ConnectionAdapters to prevent connections
  module ActiveRecord
    module ConnectionAdapters
      class AbstractAdapter
        def self.new(*)
          # Return our mock adapter
          ActiveRecord::Base.connection
        end
      end
    end
  end
  
  # Also patch ActiveRecord::Tasks so rake db:* tasks don't fail
  if defined?(ActiveRecord::Tasks::DatabaseTasks)
    module ActiveRecord
      module Tasks
        class DatabaseTasks
          def self.create(*args)
            # No-op
          end
          
          def self.drop(*args)
            # No-op
          end
          
          def self.purge(*args)
            # No-op
          end
          
          def self.structure_dump(*args)
            # No-op
          end
          
          def self.structure_load(*args)
            # No-op
          end
          
          def self.check_protected_environments!
            # No-op
          end
