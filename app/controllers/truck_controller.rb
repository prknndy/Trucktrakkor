class TruckController < ApplicationController
     
  def by_location
    # Not currently used
  end
  
  # Displays single truck
  def show
    @trucks = Truck.paginate( :conditions => ["id = ?", params[:id]], :page => params[:page])
    
    if !update_and_set
      redirect_to root_url
      return
    end
    
    respond_to do |format| 
      format.html # show.html.erb  
      format.xml { render :xml => @trucks }
    end
  end
  
  # Displays all trucks in passed category for selected city
  # TODO: Not currently used with new category page, consider eliminating or incorporating? 
  def category
    set_city
    city = @city
    
    category = Category.find(params[:id])
    @trucks = category.trucks.paginate(:all, :conditions => ["city = ?", city], :page => params[:page], :order => "name ASC", :per_page => 5)
    
    if (update_and_set)
      render :action => "show"
    else
      redirect_to root_url
      return
    end
  end
  
  # Handles a search query:
  # If NO address string is passed:
  # Trucks are first checked for a name match, if none are found, categories are searched
  # and all trucks for that category + cur. city are returned. 
  # Returns a notice if nothing is found.
  # If an address string IS passed:
  # Same as above, but if no search string is passed, all trucks for the cur. city are
  # returned.
  def search
    
    set_city
    city = @city
    
    
    if params['address_string'].empty? and params['search_string'].empty?
      flash[:error] = "You must enter a search term or address." 
      redirect_to root_url
      return
    end
    
    # Get the trucks
    # First check if the search string matches a name
    # if not, check for a category
    # otherwise, show a no results view 
    # *Unless* we are processing a location search
    # in which case, show all trucks for that city
    # TODO: Change to a search so an exact match is not required, esp. for name
    # TODO: req a search string even for address searches?
    if !(params['search_string'].empty?)
      @title = params['search_string']
      @trucks = Truck.paginate(:conditions => ["city = ? and name = ?", city, params['search_string']], :order => "name ASC", :page => params[:page], :per_page => 5)
      if (@trucks.count < 1)
        category = Category.find_by_name(params['search_string'])
        if category
          @trucks = category.trucks.paginate(:all, :conditions => ["city = ?", city], :page => params[:page], :order => "name ASC", :per_page => 5)
        end
      end
    else
      @title = params['address_string']
      @trucks = Truck.paginate(:conditions => ["city = ?", city], :page => params[:page], :order => "name ASC", :per_page => 5)
    end
    
    # If an address is passed, geolocate
    if !(params['address_string'].empty?)
      @center_location = Location.get_location(params['address_string'], city, false)
      if @center_location.nil?
        flash[:error] = "That address doesn't seem to be valid."
        redirect_to root_url
        return
      end
    end

    if (update_and_set)
      render :action => "show"
    else
      redirect_to root_url
      return
    end
  end
  
  private
  
  # Updates all trucks in @trucks and calculates the map parameters
  # returns true if at least one truck has a recent tweet and can be displayed, false otherwise.
  # TODO: should use a parameter, not @trucks?
  def update_and_set
    # Stores each trucks most recent location tweet, if it has one
    @location_tweets = []
      
    # Update the trucks
    @trucks.each do |truck|
      our_loc_tweet = truck.update_from_twitter
      if (our_loc_tweet)
        @location_tweets.push(our_loc_tweet)
      end
      if (truck.tweets.count < 1) # Don't bother displaying trucks that don't have any current tweets
        @trucks.delete(truck)
      end
    end
    
    if (@trucks.count < 1)
      flash[:notice] = "Your search turned up no trucks that have been active in the past day."
      return false
    end
    # If there is at least one truck with a valid location, set the map stuff
    if @location_tweets.count > 0
      if @center_location.nil?
        set_center
      end
      set_zoom
    end
    true
  end
  
  # sets map center based on average of current map points
  def set_center
    avg_lat = Float(0.0)
    avg_lng = Float(0.0)
    @location_tweets.each do |tweet|
      avg_lat += tweet.location.lat.to_f
      avg_lng += tweet.location.lng.to_f
    end
    avg_lat = avg_lat/@location_tweets.count
    avg_lng = avg_lng/@location_tweets.count
    @center_location = Location.new( :lat => avg_lat.to_s, :lng => avg_lng.to_s)
  end
  
  # determines zoom level for map
  def set_zoom
    # find maximum distance from map center
    max_dist = Float(0.1)
    @location_tweets.each do |tweet|
      cur_dist = @center_location.get_dist(tweet.location)
      if (cur_dist > max_dist)
        max_dist = cur_dist
      end
    end
    # set zoom 
    # TODO: These values need adjusting
    if (max_dist > 2)
        @zoom = 8
    elsif (max_dist > 0.5)
        @zoom = 10
    else
        @zoom = 15
    end
  end
  
end
