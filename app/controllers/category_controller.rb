class CategoryController < ApplicationController
  before_filter :set_city
    
  def index
    @categories = Category.order("name")
    @category = Category.first
    respond_to do |format| 
      format.html # index.html.erb  
    end
  end
  
  def show_trucks
    @category = Category.find(params[:id])
    respond_to do |format|
      format.html { redirect_to truck_category_path(@category.id)}
      format.js
    end
  end
  
end
