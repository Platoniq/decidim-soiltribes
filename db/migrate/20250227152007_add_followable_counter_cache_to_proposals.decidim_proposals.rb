# frozen_string_literal: true

# This migration comes from decidim_proposals (originally 20210310102839)
class AddFollowableCounterCacheToProposals < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_proposals_proposals, :follows_count, :integer, null: false, default: 0
    add_index :decidim_proposals_proposals, :follows_count

    reversible do |dir|
      dir.up do
        Decidim::Proposals::Proposal.reset_column_information
        Decidim::Proposals::Proposal.find_each do |record|
          record.class.reset_counters(record.id, :follows)
        end
      end
    end
  end
end
