# frozen_string_literal: true

module Decidim
  module LayoutHelperOverride
    extend ActiveSupport::Concern

    included do
      def favicon
        return if current_organization.favicon.blank?

        safe_join(Decidim::OrganizationFaviconUploader::SIZES.map do |version, size|
          favicon_link_tag(current_organization.attached_uploader(:favicon).variant_url(version), sizes: "#{size}x#{size}")
        end)
      end

      def apple_favicon
        icon_image = current_organization.attached_uploader(:favicon).variant_url(:medium)
        return unless icon_image

        favicon_link_tag(icon_image, rel: "apple-touch-icon", type: "image/png")
      end

      def legacy_favicon
        variant = :favicon if current_organization.favicon.content_type != "image/vnd.microsoft.icon"
        icon_image = current_organization.attached_uploader(:favicon).variant_url(variant)
        return unless icon_image

        favicon_link_tag(icon_image, rel: "icon", sizes: "any", type: nil)
      end
    end
  end
end
