# frozen_string_literal: true

host = ENV.fetch("APP_HOST", "soiltribes.platoniq.net")

Rails.application.routes.default_url_options[:host] = host

ActionMailer::Base.default_url_options = {
  host:,
  protocol: "https"
}
