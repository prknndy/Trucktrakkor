require 'xml'

class Truck < ActiveRecord::Base
  attr_accessible :name, :city, :twitter_id, :recent_tweet_id
  has_many :tweets
  has_and_belongs_to_many :categories
  
  def update_from_twitter
    
    # Only update a maximum of every _update_wait_ minutes to avoid getting blacklisted
    update_wait = 1
  	if (time_since_update > update_wait)
  		# Open twitter feed
  		if (self.recent_tweet.nil?)
        # If this is the first time we are updating this truck, we shouldn't use the since_id var
        self.recent_tweet = "1"
        get_recent = '?'
  		else
        get_recent = "?since_id=#{self.recent_tweet}&"
  		end
  		twitter_source = "http://api.twitter.com/1/statuses/user_timeline.xml#{get_recent}user_id=#{self.twitter_id}&trim_user=true"
  		parser = XML::Parser.file(twitter_source)
  		doc = parser.parse
  		nodes = doc.find('status')
  		nodes.each do |node|
  		  # Update Recent Tweet ID if needed
        new_id = node.find_first('id').inner_xml
        if (new_id.to_i > self.recent_tweet.to_i)
          self.recent_tweet = new_id
        end
        # Create New Tweet 
  		  self.tweets.create({:text => node.find_first('text').inner_xml, :created_at => node.find_first('created_at').inner_xml})
  		end
  		self.save
  		self.remove_old_tweets()

  		
  	end
  	
  	# Find newest valid location
  	location_tweet = self.tweets.order("created_at DESC").where("location_id > 0").first
  	location_tweet
  end
  
  def remove_old_tweets
    # Remove tweets older than a day
    self.tweets.where("created_at < ?", Time.now.utc - 60*60*24).each do |t|
      t.destroy
    end
  end

  def time_since_update
    if (self.updated_at.nil?)
      11
    else
      (Time.now.utc - self.updated_at)/60
    end
  end

end
