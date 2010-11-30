class Admin::LocationController < ApplicationController
  before_filter :authenticate, :set_city
  
  def index
    @locations = Location.paginate( :conditions => ["city = ?", @city], :page => params[:page])
  end
  
  def edit
    @location = Location.find(params[:id])    
  end
  
  def create
    @location = Location.new(params[:location])
    if @location.save
      flash[:notice] = "New location created"
      redirect_to :action => :index
    else
      flash[:error] = "Could not create new location"
      render 'new'
    end
  end
  
  def update
    @location = Location.find(params[:id])
    if @location.update_attributes(params[:location])
      flash[:notice] = "Location updated"
      redirect_to :action => :index
    else
      flash[:error] = "Location could not be updated"
      render 'edit'
    end
  end
  
  def new
    @location = Location.new()
  end
  
  def destroy
    Location.find(params[:id]).destroy
    flash[:notice] = "Location has been deleted"
    redirect_to :action => :index
  end
end
