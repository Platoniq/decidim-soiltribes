# frozen_string_literal: true

module Decidim
  module Superspaces
    module Admin
      module CreateSuperspaceTaxonomy
        private

        def create_superspace!
          super
          @superspace.taxonomizations = form.taxonomizations
        end
      end
    end
  end
end
