class TruckController < ApplicationController
    
  def by_location
    # Not currently used
  end
  
  def by_name
    
    # Pull current city from the session, or check in the parameters if it doesn't exist
    # TODO: Use cookie instead of session?
    # TODO: Consider simplier ways to pass the city parameter/session
    if (session[:current_city].nil?)
      if (params['city'].nil? or params['city'].empty?)
        flash[:error] = "No city selected."
        redirect_to root_url
        return
      else
        city = params['city']
      end
    else
      city = session[:current_city]
    end
    
    
    if params['address_string'].empty? and params['search_string'].empty?
      flash[:error] = "You must enter a search term or address." 
      redirect_to root_url
      return
    end
    
    # Get the trucks
    # First check if the search string matches a name
    # if not, check for a category
    # otherwise, show a no results view 
    # unless we are processing a location search
    # in which case, show all trucks for that city
    # TODO: Change to a search so an exact match is not required, esp. for name
    # TODO: req a search string even for address searches?
    if !(params['search_string'].empty?)
      @title = params['search_string']
      @trucks = Truck.find_all_by_name_and_city(params['search_string'], city)
      if (@trucks.count < 1)
        category = Category.find_by_name(params['search_string'])
        if category
          @trucks = category.trucks.find(:all, :conditions => ["city = ?", city])
        end
      end
    else
      @title = params['address_string']
      @trucks = Truck.find_all_by_city(city)
    end
    
    if !(params['address_string'].empty?)
      @center_location = Location.get_location(params['address_string'], city, false)
      if @center_location.nil?
        flash[:error] = "That address doesn't seem to be valid."
        redirect_to root_url
        return
      end
    end

    if (@trucks.count < 1)
      flash[:notice] = "Your search turned up no results."
      redirect_to root_url
      return
    end
    
    @location_tweets = []
    # Update the trucks

    @trucks.each do |truck|
      our_loc_tweet = truck.update_from_twitter
      if (our_loc_tweet)
        @location_tweets.push(our_loc_tweet)
      end
    end
    
    if @location_tweets.count > 0
      if @center_location.nil?
        set_center
      end
      set_zoom
    end
    
    respond_to do |format| 
      format.html # by_name.html.erb  
      format.xml { render :xml => @trucks }
    end
  end
  
  def set_center
    # sets map center based on average of current map points
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
  
  def set_zoom
    # determines zoom level for map
    
    # find maximum distance from map center
    max_dist = Float(0.1)
    @location_tweets.each do |tweet|
      cur_dist = @center_location.get_dist(tweet.location)
      if (cur_dist > max_dist)
        max_dist = cur_dist
      end
    end
    # set zoom 
    if (max_dist > 2)
        @zoom = 8
    elsif (max_dist > 0.5)
        @zoom = 10
    else
        @zoom = 15
    end
  end
  
end
