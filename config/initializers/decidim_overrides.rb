# frozen_string_literal: true

Rails.application.config.to_prepare do
  Decidim::LayoutHelper.include(Decidim::LayoutHelperOverride)
end
