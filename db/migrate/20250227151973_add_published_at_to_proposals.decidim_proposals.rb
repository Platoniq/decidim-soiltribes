# frozen_string_literal: true

# This migration comes from decidim_proposals (originally 20171220084719)
class AddPublishedAtToProposals < ActiveRecord::Migration[5.1]
  def up
    add_column :decidim_proposals_proposals, :published_at, :datetime
    add_index :decidim_proposals_proposals, :published_at
    # rubocop:disable Rails/SkipsModelValidations
    Decidim::Proposals::Proposal.update_all("published_at = updated_at")
    # rubocop:enable Rails/SkipsModelValidations
  end

  def down
    remove_column :decidim_proposals_proposals, :published_at
  end
end
