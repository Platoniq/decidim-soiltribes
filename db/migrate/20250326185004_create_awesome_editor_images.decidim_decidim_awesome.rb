# frozen_string_literal: true

# This migration comes from decidim_decidim_awesome (originally 20200324230936)
class CreateAwesomeEditorImages < ActiveRecord::Migration[5.2]
  def change
    create_table :decidim_awesome_editor_images do |t|
      t.string :image
      t.string :path
      t.references :decidim_author, null: false, foreign_key: { to_table: :decidim_users }, index: { name: "decidim_awesome_editor_images_author" }
      t.references :decidim_organization, null: false, foreign_key: true, index: { name: "decidim_awesome_editor_images_constraint_organization" }

      t.timestamps
    end
  end
end
