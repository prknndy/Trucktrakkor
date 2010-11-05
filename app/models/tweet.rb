class Tweet < ActiveRecord::Base
  attr_accessible :text, :created_at, :location
  belongs_to :truck
  belongs_to :location
  
  after_create :search_for_location
  
  def get_time_since
    # TODO remove 's' for singular time sinces
    minutes_since = Integer((Time.now.utc - self.created_at)/60)
    if minutes_since > 60
      if minutes_since > (60*24) 
        # days
        days = Integer(minutes_since/(60*24))
        "#{days} days ago"
      else
        # hours
        hours = Integer(minutes_since/60)
        "#{hours} hours ago"
      end
    else
      # minutes
      "#{minutes_since} minutes ago"
    end
  end
  
  def search_for_location
    
    our_location = Location.valid_location?(self.text, self.truck.city)
    if (our_location)
      self.location = our_location
      # TODO: Consider the proper way to save the tweet and location after a location is associated
      self.save
      true
    else
      false
    end  
  end
  
  
end
