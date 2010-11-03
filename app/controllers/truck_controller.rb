class TruckController < ApplicationController
    
  def by_location
    # Not currently used
  end
  
  def by_name
    
    if params['address_string'].empty? and params['search_string'].empty?
      flash[:error] = "You must enter a search term or address." 
      redirect_to root_url
      return
    end
    
    # Get the trucks
    # First check if the search string matches a name
    # if not, check for a category
    # otherwise, show a no results view
    # TODO: Change to a search so an exact match is not required, esp. for name
    # TODO: implement cities
    
    if !(params['search_string'].empty?)
      @title = params['search_string']
      @trucks = Truck.find_all_by_name(params['search_string'])
      if (@trucks.count < 1)
        our_category = Category.find_by_name(params['search_string'])
        if (our_category)
          @trucks = our_category.trucks
        end
      end
    else
      @title = params['address_string']
      @trucks = Truck.all
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
    
    respond_to do |format| 
      format.html # by_name.html.erb  
      format.xml { render :xml => @trucks }
    end
  end
  
  def index
    @trucks = Truck.all
    @title = 'HELLO!'
    #respond_to do |format| 
    #  format.html # index.html.erb  
    #  format.xml { render :xml => @trucks }
    #end
  end
end
