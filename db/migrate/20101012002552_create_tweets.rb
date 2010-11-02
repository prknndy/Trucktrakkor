class CreateTweets < ActiveRecord::Migration
  def self.up
    create_table :tweets do |t|
      t.text :text
      t.timestamp :created_at
      t.references :truck
      t.references :location

    end
  end

  def self.down
    drop_table :tweets
  end
end
