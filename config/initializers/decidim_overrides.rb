# frozen_string_literal: true

Rails.application.config.to_prepare do
  Decidim::LayoutHelper.include(Decidim::LayoutHelperOverride)
  Decidim::TaxonomiesHelper.prepend(Decidim::TaxonomiesHelperOverride)

  # Superspace taxonomy support
  Decidim::Superspaces::Superspace.include(Decidim::Superspaces::TaxonomizableSuperspace)
  # Include HasTaxonomyFormAttributes first, then prepend our override so its
  # taxonomy_filters/participatory_space_manifest methods take precedence.
  Decidim::Superspaces::Admin::SuperspaceForm.include(Decidim::HasTaxonomyFormAttributes)
  Decidim::Superspaces::Admin::SuperspaceForm.prepend(Decidim::Superspaces::Admin::SuperspaceFormTaxonomy)
  Decidim::Superspaces::Admin::CreateSuperspace.prepend(Decidim::Superspaces::Admin::CreateSuperspaceTaxonomy)
  Decidim::Superspaces::Admin::UpdateSuperspace.prepend(Decidim::Superspaces::Admin::UpdateSuperspaceTaxonomy)
end
