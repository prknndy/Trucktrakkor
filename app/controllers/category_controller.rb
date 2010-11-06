class CategoryController < ApplicationController
    
  def index
    @categories = Category.order("name")
    
    set_city
    
    respond_to do |format| 
      format.html # index.html.erb  
    end
  end
end
