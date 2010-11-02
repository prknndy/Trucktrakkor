class RemoveTruckTagLocationTweet < ActiveRecord::Migration
  def self.up
    change_table :trucks do |t|
      t.remove :tag, :location_tweet_id
    end
  end

  def self.down
  end
end
