# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

# Create cities
chicago = City.find_or_create_by_name({:name => 'chicago', :display_name => 'Chicago'})
sanfrancisco = City.find_or_create_by_name({:name => 'sanfrancisco', :display_name => "San Francisco"})
newyork = City.find_or_create_by_name({:name => 'newyork', :display_name => 'New York'})

# Create categories
# meal times
breakfast = Category.find_or_create_by_name({:name => 'breakfast'})
lunch = Category.find_or_create_by_name({:name => 'lunch'})
dinner = Category.find_or_create_by_name({:name => 'dinner'})
  
# cuisines
asian = Category.find_or_create_by_name({:name => 'asian'})
dessert = Category.find_or_create_by_name({:name => 'dessert'})
sandwiches = Category.find_or_create_by_name({:name => 'sandwiches'})

# other
delivers = Category.find_or_create_by_name({:name => 'delivers'})
storefront = Category.find_or_create_by_name({:name => 'storefront'})

# Create the food trucks
Truck.find_or_create_by_name({:name => 'FossFoodTrucks', :city => 'chicago', :twitter_id => '174257311'}).categories = [lunch, sandwiches]
Truck.find_or_create_by_name({:name => 'FlirtyCupcakes', :city => 'chicago', :twitter_id => '102121312'}).categories = [lunch, dessert]
Truck.find_or_create_by_name({:name => 'HappyBodega', :city => 'chicago', :twitter_id => '138527765'}).categories = [sandwiches, lunch]

