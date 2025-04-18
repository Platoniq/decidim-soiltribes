# frozen_string_literal: true

# This migration comes from decidim_participatory_processes (originally 20161025125300)
class AddPublishedAtToProcesses < ActiveRecord::Migration[5.0]
  def change
    add_column :decidim_participatory_processes, :published_at, :datetime
    add_index :decidim_participatory_processes, :published_at
  end
end
