class Tweet < ActiveRecord::Base
  attr_accessible :text, :created_at, :location
  belongs_to :truck
  belongs_to :location
  
  after_create :search_for_location
  
  def search_for_location
    
    our_location = Location.valid_location?(self.text)
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
