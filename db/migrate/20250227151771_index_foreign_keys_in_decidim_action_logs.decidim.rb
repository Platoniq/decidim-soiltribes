# frozen_string_literal: true

# This migration comes from decidim (originally 20200320105904)
class IndexForeignKeysInDecidimActionLogs < ActiveRecord::Migration[5.2]
  def change
    add_index :decidim_action_logs, :decidim_area_id
    add_index :decidim_action_logs, :decidim_scope_id
  end
end
