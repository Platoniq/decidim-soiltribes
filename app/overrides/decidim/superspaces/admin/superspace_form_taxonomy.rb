# frozen_string_literal: true

module Decidim
  module Superspaces
    module Admin
      # Prepended onto SuperspaceForm after HasTaxonomyFormAttributes is included,
      # so these methods take precedence in the ancestor chain.
      module SuperspaceFormTaxonomy
        def participatory_space_manifest
          "superspaces"
        end

        # Use all space-tagged taxonomy filters for the org (same set as /spaces page),
        # rather than filtering by a single manifest.
        def taxonomy_filters
          @taxonomy_filters ||= all_taxonomy_filters.space_filters
        end
      end
    end
  end
end
