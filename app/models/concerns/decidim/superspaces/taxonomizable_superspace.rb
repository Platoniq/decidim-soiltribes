# frozen_string_literal: true

module Decidim
  module Superspaces
    module TaxonomizableSuperspace
      extend ActiveSupport::Concern

      included do
        include Decidim::Taxonomizable

        scope :public_spaces, -> { all }
      end

      def published_at
        created_at
      end
    end
  end
end
