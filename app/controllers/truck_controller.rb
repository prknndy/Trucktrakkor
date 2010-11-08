class TruckController < ApplicationController
     
  def by_location
    # Not currently used
  end
  
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
  
  def category
    set_city
    city = @city
    
    category = Category.find(params[:id])
    @trucks = category.trucks.paginate(:all, :conditions => ["city = ?", city], :page => params[:page], :per_page => 5)
    
    if (update_and_set)
      render :action => "show"
    else
      redirect_to root_url
      return
    end
  end
  
  def by_name
    
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
    # unless we are processing a location search
    # in which case, show all trucks for that city
    # TODO: Change to a search so an exact match is not required, esp. for name
    # TODO: req a search string even for address searches?
    if !(params['search_string'].empty?)
      @title = params['search_string']
      @trucks = Truck.paginate(:conditions => ["city = ? and name = ?", city, params['search_string']], :page => params[:page], :per_page => 5)
      if (@trucks.count < 1)
        category = Category.find_by_name(params['search_string'])
        if category
          @trucks = category.trucks.paginate(:all, :conditions => ["city = ?", city], :page => params[:page], :per_page => 5)
        end
      end
    else
      @title = params['address_string']
      @trucks = Truck.paginate(:conditions => ["city = ?", city], :page => params[:page], :per_page => 5)
    end
    
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
  
  def update_and_set
    # Updates the trucks and configures the map
    # requires @trucks to be populated
    
    @location_tweets = []
    # Update the trucks

    @trucks.each do |truck|
      if (truck.tweets.count < 1)
        @trucks.delete(truck)
        next
      end
      our_loc_tweet = truck.update_from_twitter
      if (our_loc_tweet)
        @location_tweets.push(our_loc_tweet)
      end
    end
    
    if (@trucks.count < 1)
      flash[:notice] = "Your search turned up no trucks that have been active in the past day."
      return false
    end
    
    if @location_tweets.count > 0
      if @center_location.nil?
        set_center
      end
      set_zoom
    end
    true
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
