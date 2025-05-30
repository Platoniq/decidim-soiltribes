# frozen_string_literal: true

# This migration comes from decidim_meetings (originally 20210310120731)
class AddFollowableCounterCacheToMeetings < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_meetings_meetings, :follows_count, :integer, null: false, default: 0
    add_index :decidim_meetings_meetings, :follows_count

    reversible do |dir|
      dir.up do
        Decidim::Meetings::Meeting.reset_column_information
        Decidim::Meetings::Meeting.find_each do |record|
          record.class.reset_counters(record.id, :follows)
        end
      end
    end
  end
end
