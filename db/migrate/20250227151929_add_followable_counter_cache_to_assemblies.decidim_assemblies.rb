# frozen_string_literal: true

# This migration comes from decidim_assemblies (originally 20210310120444)
class AddFollowableCounterCacheToAssemblies < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_assemblies, :follows_count, :integer, null: false, default: 0
    add_index :decidim_assemblies, :follows_count

    reversible do |dir|
      dir.up do
        Decidim::Assembly.reset_column_information
        Decidim::Assembly.find_each do |record|
          record.class.reset_counters(record.id, :follows)
        end
      end
    end
  end
end
