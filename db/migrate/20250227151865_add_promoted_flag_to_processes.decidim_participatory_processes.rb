# frozen_string_literal: true

# This migration comes from decidim_participatory_processes (originally 20161013134732)
class AddPromotedFlagToProcesses < ActiveRecord::Migration[5.0]
  def change
    add_column :decidim_participatory_processes, :promoted, :boolean, default: false
    add_index :decidim_participatory_processes, :promoted
  end
end
