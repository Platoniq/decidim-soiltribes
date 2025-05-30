# frozen_string_literal: true

# This migration comes from decidim_proposals (originally 20210310120812)
class AddFollowableCounterCacheToCollaborativeDrafts < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_proposals_collaborative_drafts, :follows_count, :integer, null: false, default: 0
    add_index :decidim_proposals_collaborative_drafts, :follows_count

    reversible do |dir|
      dir.up do
        Decidim::Proposals::CollaborativeDraft.reset_column_information
        Decidim::Proposals::CollaborativeDraft.find_each do |record|
          record.class.reset_counters(record.id, :follows)
        end
      end
    end
  end
end
