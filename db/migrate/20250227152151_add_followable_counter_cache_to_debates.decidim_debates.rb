# frozen_string_literal: true

# This migration comes from decidim_debates (originally 20210310120652)
class AddFollowableCounterCacheToDebates < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_debates_debates, :follows_count, :integer, null: false, default: 0
    add_index :decidim_debates_debates, :follows_count

    reversible do |dir|
      dir.up do
        Decidim::Debates::Debate.reset_column_information
        Decidim::Debates::Debate.find_each do |record|
          record.class.reset_counters(record.id, :follows)
        end
      end
    end
  end
end
