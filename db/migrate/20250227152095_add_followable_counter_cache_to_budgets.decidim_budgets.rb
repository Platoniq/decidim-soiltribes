# frozen_string_literal: true

# This migration comes from decidim_budgets (originally 20210310120613)
class AddFollowableCounterCacheToBudgets < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_budgets_projects, :follows_count, :integer, null: false, default: 0
    add_index :decidim_budgets_projects, :follows_count

    reversible do |dir|
      dir.up do
        Decidim::Budgets::Project.reset_column_information
        Decidim::Budgets::Project.find_each do |record|
          record.class.reset_counters(record.id, :follows)
        end
      end
    end
  end
end
