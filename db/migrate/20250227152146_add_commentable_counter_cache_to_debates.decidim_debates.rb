# frozen_string_literal: true

# This migration comes from decidim_debates (originally 20200827154116)
class AddCommentableCounterCacheToDebates < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_debates_debates, :comments_count, :integer, null: false, default: 0
    add_index :decidim_debates_debates, :comments_count
    Decidim::Debates::Debate.reset_column_information

    # rubocop:disable Rails/SkipsModelValidations
    Decidim::Debates::Debate.includes(:comments).find_each do |debate|
      debate.update_columns(comments_count: debate.comments.not_hidden.count)
    end
    # rubocop:enable Rails/SkipsModelValidations
  end
end
