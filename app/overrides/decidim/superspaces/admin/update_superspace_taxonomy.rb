# frozen_string_literal: true

module Decidim
  module Superspaces
    module Admin
      module UpdateSuperspaceTaxonomy
        private

        def update_superspace!
          super
          superspace.taxonomizations = form.taxonomizations
        end
      end
    end
  end
end
