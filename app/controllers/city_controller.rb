class CityController < ApplicationController
  
  def show
    if city = City.find(params[:id])
      session[:current_city] = city.name
    end
    redirect_to root_url
  end
  
end
