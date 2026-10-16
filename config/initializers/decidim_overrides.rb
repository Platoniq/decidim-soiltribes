# frozen_string_literal: true

Rails.application.config.to_prepare do
  Decidim::LayoutHelper.include(Decidim::LayoutHelperOverride)
  Decidim::Debates::Admin::DebateForm.prepend(Decidim::Debates::Admin::DebateFormLockedLayout)
end
