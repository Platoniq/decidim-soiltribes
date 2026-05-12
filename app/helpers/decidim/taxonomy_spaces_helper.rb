# frozen_string_literal: true

module Decidim
  module TaxonomySpacesHelper
    include Decidim::CheckBoxesTreeHelper

    def filter_sections
      Decidim::TaxonomyFilter.for(current_organization).space_filters.filter_map do |taxonomy_filter|
        next unless taxonomy_filter.filter_items.any?

        {
          method: "with_any_taxonomies[#{taxonomy_filter.root_taxonomy_id}]",
          collection: filter_taxonomy_values_for(taxonomy_filter),
          label: decidim_sanitize_translated(taxonomy_filter.name),
          id: "taxonomy"
        }
      end
    end
  end
end
