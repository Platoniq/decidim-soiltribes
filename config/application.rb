# frozen_string_literal: true

require_relative "boot"

require "decidim/rails"

# Add the frameworks used by your app that are not loaded by Decidim.
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_cable/engine"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DecidimSoiltribes
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.2

    # Rails 7.1 removed Rails.application.secrets, which this app still reads in
    # config/environments and throughout config/initializers. config/secrets.yml
    # already has the shape config_for expects.
    #
    # This has to live here rather than in an initializer: Rails loads
    # config/environments/production.rb during bootstrap, before
    # config/initializers/* runs, and that file reads secrets on line 44.
    def secrets
      @secrets ||= ActiveSupport::OrderedOptions.new.merge(
        config_for(:secrets).deep_symbolize_keys
      )
    end

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
