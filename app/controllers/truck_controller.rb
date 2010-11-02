class TruckController < ApplicationController
    
  def by_location
    
  end
  
  def by_name
    
    if params['address_string']
      by_location
    end
    
    # Get the trucks
    # First check if the search string matches a name
    # if not, check for a category
    # otherwise, show a no results view
    # TODO: Change to a search so an exact match is not required, esp. for name
    # TODO: implement cities
    @title = params['search_string']
    @trucks = Truck.find_all_by_name(params['search_string'])
    if (@trucks.count < 1)
      #@trucks = Truck.find_all_by_category(params['search_string'])
      @trucks = Category.find_by_name(params['search_string']).trucks
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
