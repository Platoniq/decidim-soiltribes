# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

gem "decidim", "0.29.2"
gem "decidim-conferences"
gem "decidim-decidim_awesome", "~> 0.12.0"
gem "decidim-superspaces", git: "https://github.com/Platoniq/decidim-superspace", branch: "main"
# gem "decidim-design", "0.29.2"
# gem "decidim-initiatives", "0.29.2"
# gem "decidim-templates", "0.29.2"
gem "bootsnap", "~> 1.3"
gem "decidim-term_customizer", git: "https://github.com/Platoniq/decidim-module-term_customizer", branch: "master"

gem "puma", ">= 6.3.1"

gem "wicked_pdf", "~> 2.1"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri

  gem "brakeman", "~> 6.1"
  gem "decidim-dev", "0.29.2"
  gem "net-imap", "~> 0.2.3"
  gem "net-pop", "~> 0.1.1"
  gem "net-smtp", "~> 0.3.1"
end

group :development do
  gem "letter_opener_web", "~> 2.0"
  gem "listen", "~> 3.1"
  gem "web-console", "~> 4.2"
end

group :production do
  gem "aws-sdk-s3", "1.160.0", require: false
  gem "sidekiq"
end
