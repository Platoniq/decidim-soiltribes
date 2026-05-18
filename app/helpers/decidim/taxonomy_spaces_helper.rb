# frozen_string_literal: true

module Decidim
  module TaxonomySpacesHelper
    include Decidim::CheckBoxesTreeHelper

    SPACE_TYPE_CONFIG = {
      "Decidim::Superspaces::Superspace" => { label_key: "superspaces", path: "/superspaces" },
      "Decidim::Assembly" => { label_key: "assemblies", path: "/assemblies" },
      "Decidim::ParticipatoryProcess" => { label_key: "processes", path: "/processes" },
      "Decidim::Conference" => { label_key: "conferences", path: "/conferences" }
    }.freeze

    def space_type_label(klass)
      key = SPACE_TYPE_CONFIG.dig(klass.name, :label_key)
      t("decidim.taxonomy_spaces.index.space_types.#{key}")
    end

    def space_type_path(klass)
      SPACE_TYPE_CONFIG.dig(klass.name, :path)
    end

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
