class Admin::TruckController < ApplicationController
  before_filter :authenticate, :get_city
  
  def index
    @trucks = Truck.find_all_by_city(@city)
  end
  
  def edit
    @truck = Truck.find(params[:id])
  end
  
  def edit_categories
    @truck = Truck.find(params[:id])
    @cat_list = ""
    @truck.categories.each do |c|
      @cat_list += " #{c.name},"
    end
  end
  
  def update_categories
    @truck = Truck.find(params[:id])
    cat_names = params['cat_list'].split(/,/)
    @truck.categories.clear
    categories_added = "Changed categories for #{@truck.name} to: "
    cat_names.each do |cat_name|
      category = Category.find_by_name(cat_name.strip)
      if category
        categories_added += cat_name + " "
          @truck.categories << category
      end
    end
    if categories_added == "Changed categories for #{@truck.name} to: "
      categories_added = "Removed all categories for #{@truck.name}"
    end
    flash[:notice] = categories_added
    redirect_to :action => 'index'
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
