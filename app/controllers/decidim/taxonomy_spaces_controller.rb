# frozen_string_literal: true

module Decidim
  class TaxonomySpacesController < Decidim::ApplicationController
    include Paginable

    helper Decidim::TaxonomySpacesHelper
    helper_method :filter, :filter_params, :collection

    def index; end

    private

    def spaces
      @spaces ||= begin
        leaf_ids = selected_taxonomy_ids
        results = space_classes.flat_map do |klass|
          all = klass.public_spaces.includes(:taxonomies).to_a
          leaf_ids.any? ? all.select { |s| s.taxonomies.map(&:id).intersect?(leaf_ids) } : all
        end
        results.sort_by { |s| s.published_at || Time.zone.at(0) }.reverse
      end
    end

    def collection
      @collection ||= paginate(Kaminari.paginate_array(spaces))
    end

    def selected_taxonomy_ids
      raw = filter_params[:with_any_taxonomies]
      return [] unless raw.is_a?(Hash)

      all_filter_ids = Decidim::TaxonomyFilter.for(current_organization)
                                              .space_filters
                                              .flat_map(&:filter_taxonomy_ids)
                                              .map(&:to_s)
      return [] if all_filter_ids.empty?

      # Keep only submitted IDs that are known filter leaf items
      selected = raw.values.flatten.compact_blank
                    .select { |id| all_filter_ids.include?(id) }
                    .uniq

      # Every item checked → no filter (show everything including untagged spaces)
      return [] if selected.empty? || selected.sort == all_filter_ids.uniq.sort

      selected.map(&:to_i)
    end

    def space_classes
      @space_classes ||= [
        ("Decidim::Assembly" if defined?(Decidim::Assembly)),
        ("Decidim::ParticipatoryProcess" if defined?(Decidim::ParticipatoryProcess)),
        ("Decidim::Conference" if defined?(Decidim::Conference)),
        ("Decidim::Superspaces::Superspace" if defined?(Decidim::Superspaces::Superspace))
      ].compact.map(&:constantize)
    end

    def filter_params
      @filter_params ||= { with_any_taxonomies: nil }.merge(
        params.to_unsafe_h[:filter]&.symbolize_keys || {}
      )
    end

    def filter
      @filter ||= Decidim::FilterResource::Filter.new(filter_params)
    end
  end
end
