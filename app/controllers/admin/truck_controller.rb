class Admin::TruckController < ApplicationController
  before_filter :authenticate, :get_city
  
  def index
    @trucks = Truck.find_all_by_city(@city)
  end
  
  def edit
    @truck = Truck.find(params[:id])
  end
  
  def update
    @truck = Truck.find(params[:id])
    if @truck.update_attributes(params[:truck])
      flash[:notice] = "Truck successfully updated"
      redirect_to :action => 'index'
    else
      flash[:error] = "Error: the truck could not be updated"
      render "edit"
    end
  end
  
  def new
    @truck = Truck.new
  end
  
  def create
    @truck = Truck.new(params[:truck])
    if @truck.save
      flash[:notice] = "Truck successfully created"
      redirect_to :action => 'index'
    else
      flash[:error] = "Error: truck could not be created"
      render 'new'
    end
  end
  
  def destroy
    Truck.find(params[:id]).destroy
    flash[:notice] = "Truck has been deleted"
    redirect_to :action => 'index'
    return
  end
    
  private
  
  def get_city
    set_city
  end
  
end
