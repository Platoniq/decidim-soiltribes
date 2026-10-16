# frozen_string_literal: true

module Decidim
  module Debates
    module Admin
      # Decidim 0.31 disables the comment layout radios once a debate has
      # comments, since the layout can no longer change. Browsers do not submit
      # disabled inputs, so only Rails' empty hidden field reaches the form and
      # every admin edit of a debate with comments fails ("cannot be blank",
      # "cannot be changed"). While the layout is locked, keep the stored one.
      # decidim develop has the same code (Oct 2026): drop this once fixed there.
      module DebateFormLockedLayout
        def comments_layout
          value = super
          return value if value.present? || !comments_layout_locked?

          debate.comments_layout.presence || "single_column"
        end
      end
    end
  end
end
