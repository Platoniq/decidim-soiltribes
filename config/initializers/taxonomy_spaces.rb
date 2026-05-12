# frozen_string_literal: true

Decidim::Core::Engine.routes do
  get "/spaces", to: "taxonomy_spaces#index", as: "taxonomy_spaces"
end

Rails.application.config.to_prepare do
  Decidim.menu :menu do |menu|
    menu.add_item :taxonomy_spaces,
                  I18n.t("decidim.taxonomy_spaces.index.menu_item"),
                  decidim.taxonomy_spaces_path,
                  position: 3.0,
                  active: :inclusive
  end

  Decidim.menu :mobile_menu do |menu|
    menu.add_item :taxonomy_spaces,
                  I18n.t("decidim.taxonomy_spaces.index.menu_item"),
                  decidim.taxonomy_spaces_path,
                  position: 3.0,
                  active: :inclusive
  end
end
