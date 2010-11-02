class CreateTrucks < ActiveRecord::Migration
  def self.up
    create_table :trucks do |t|
      t.string :city
      t.string :name
      t.text :tag
      t.references :location_tweet
      t.string :twitter_id
      t.integer :recent_tweet_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :trucks
  end
end
