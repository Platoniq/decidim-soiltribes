# frozen_string_literal: true

Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  mount Decidim::Core::Engine => "/"
  # authenticate :user, ->(u) { u.admin? } do
  #   mount Sidekiq::Web => "/sidekiq"
  # end
end
