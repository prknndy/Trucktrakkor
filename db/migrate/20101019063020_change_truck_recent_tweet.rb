class ChangeTruckRecentTweet < ActiveRecord::Migration
  def self.up
    change_table :trucks do |t|
      t.remove :last_twitter_feed
      t.string :recent_tweet
    end
  end

  def self.down
    change_table :trucks do |t|
         t.integer :last_twitter_feed
         t.remove :recent_tweet
    end
  end
end
