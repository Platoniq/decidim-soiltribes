# Add this to the beginning of config/application.rb or config/boot.rb

if ENV['RAILS_SKIP_DB_CONNECTION'] == 'true'
  puts "⚠️ RAILS_SKIP_DB_CONNECTION is set to true. Completely skipping ActiveRecord."
  
  # Remove ActiveRecord from Rails modules to skip database initialization
  if defined?(Rails::Application::Configuration)
    class Rails::Application::Configuration
      def database_configuration
        # Return empty config
        {}
      end
    end
  end
  
  # Patch Rails to skip loading ActiveRecord
  module Rails
    class << self
      def application
        @application ||= (remove_const(:Application) if defined?(Application); const_set(:Application, Class.new(Rails::Application)))
      end
    end
  end
  
  # Delete ActiveRecord from Rails frameworks
  if defined?(Rails::Application)
    Rails::Application.config.eager_load_namespaces.delete(ActiveRecord) if defined?(ActiveRecord)
    
    module Rails
      class Application
        class Configuration
          def frameworks
            frameworks = [:action_controller, :action_view, :action_mailer, :rails_test_unit, :sprockets]
            frameworks << :action_cable if defined?(::ActionCable)
            frameworks
          end
        end
      end
    end
  end
end
