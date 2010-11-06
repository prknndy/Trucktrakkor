class ApplicationController < ActionController::Base
  
  #rescue_from ActiveRecord::RecordNotFound, :with => :route_not_found
  #rescue_from ActionController::RoutingError, :with => :route_not_found
  protect_from_forgery
  
  def set_city
    # Pull current city from the session, or check in the parameters if it doesn't exist
    # TODO: Use cookie instead of session?
    # TODO: Consider simplier ways to pass the city parameter/session
    if (session[:current_city].nil?)
      if (params['city'].nil? or params['city'].empty?)
        flash[:error] = "No city selected."
        redirect_to root_url
        return
      else
        @city = params['city']
      end
    else
      @city = session[:current_city]
    end
    @city
  end
  
  private
  
  def route_not_found
    flash[:error] = "404 - Page Not Found"
    redirect_to root_url
    return
  end
end
