class CategoryController < ApplicationController
  before_filter :set_city
  
  # Displays index of categories valid for the currently selected city
  def index
    # TODO: There has got to be a way to preselect categories that have trucks in the current city
    #       rather than filter them in the view, which doesn't seem appropriate.
    @categories = Category.order("name")
    respond_to do |format| 
      format.html # index.html.erb  
    end
  end
  
  # Displays list of trucks for the passed category, should only be called Asyns.
  def show_trucks
    @category = Category.find(params[:id])
    respond_to do |format|
      format.html { redirect_to truck_category_path(@category.id)}
      format.js
    end
  end
  
end
