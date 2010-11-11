class Admin::CategoryController < ApplicationController
  before_filter :authenticate
  
  def index
    @categories = Category.all
    @category = Category.new
  end
  
  def create
    category = Category.new(params[:category])
    if category.save
      flash[:notice] = "#{category.name} category created"
    else
      flash[:error] = "Error: that category cannot be created"
    end
    redirect_to :action => "index"
  end
  
  def destroy
    # TODO: check need to remove deleted category references from truckxcategory join table
    Category.find(params[:id]).destroy
    flash[:notice] = "Category deleted"
    redirect_to :action => "index"
  end
end
