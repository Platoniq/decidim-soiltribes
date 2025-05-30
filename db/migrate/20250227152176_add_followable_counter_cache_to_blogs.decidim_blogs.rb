# frozen_string_literal: true

# This migration comes from decidim_blogs (originally 20210310120514)
class AddFollowableCounterCacheToBlogs < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_blogs_posts, :follows_count, :integer, null: false, default: 0
    add_index :decidim_blogs_posts, :follows_count

    reversible do |dir|
      dir.up do
        Decidim::Blogs::Post.reset_column_information
        Decidim::Blogs::Post.find_each do |record|
          record.class.reset_counters(record.id, :follows)
        end
      end
    end
  end
end
