# frozen_string_literal: true

module Decidim
  module TaxonomiesHelperOverride
    # Overrides the default single-select to a multi-select so that a
    # participatory space can be tagged with more than one taxonomy value
    # from the same filter (e.g. both Education and Business).
    def filter_taxonomy_items_select_field(form, name, filter, options = {})
      label = decidim_sanitize_translated(filter.name)
      items = taxonomy_items_options_for_filter(filter)

      options = options.merge(label:) unless options.has_key?(:label)
      # Drop include_blank — it makes no sense in a multi-select context
      options = options.except(:include_blank)

      form.select(
        name,
        items,
        options,
        { name: "#{form.object_name}[#{name}][]", id: "#{name}-#{filter.id}", multiple: true, size: [items.length, 8].min }
      )
    end
  end
end
