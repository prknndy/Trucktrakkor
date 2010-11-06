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
filipino = Category.find_or_create_by_name({:name => 'filipino'})
french = Category.find_or_create_by_name({:name => 'french'})
indian = Category.find_or_create_by_name({:name => 'indian'})
japanese = Category.find_or_create_by_name({:name => 'japanese'})
mexican = Category.find_or_create_by_name({:name => 'mexican'})
# food items
burgers = Category.find_or_create_by_name({:name => 'burgers'})
cupcakes = Category.find_or_create_by_name({:name => 'cupcakes'})
dessert = Category.find_or_create_by_name({:name => 'dessert'})
sandwiches = Category.find_or_create_by_name({:name => 'sandwiches'})
tamales = Category.find_or_create_by_name({:name => 'tamales'})
soup = Category.find_or_create_by_name({:name => 'soup'})
seafood = Category.find_or_create_by_name({:name => 'seafood'})
sushi = Category.find_or_create_by_name({:name => 'sushi'})
# other
bars = Category.find_or_create_by_name({:name => 'bars'})
delivers = Category.find_or_create_by_name({:name => 'delivers'})
storefront = Category.find_or_create_by_name({:name => 'storefront'})
organic = Category.find_or_create_by_name({:name => 'organic'})

# Create the food trucks
Truck.find_or_create_by_name({:name => 'FossFoodTrucks', :city => 'chicago', :twitter_id => '174257311'}).categories = [lunch, sandwiches]
Truck.find_or_create_by_name({:name => 'FlirtyCupcakes', :city => 'chicago', :twitter_id => '102121312'}).categories = [lunch, dessert]
Truck.find_or_create_by_name({:name => 'HappyBodega', :city => 'chicago', :twitter_id => '138527765'}).categories = [sandwiches, lunch]

Truck.find_or_create_by_name({:name => 'wherezthewagon', :city => 'chicago', :twitter_id => '114951373', :website => 'http://www.gaztro-wagon.com/'}).categories = [lunch, dinner, storefront] 
Truck.find_or_create_by_name({:name => 'cremebruleecart', :city => 'sanfrancisco', :twitter_id => '25612932'}).categories = [dessert,lunch,dinner] 
Truck.find_or_create_by_name({:name => 'magiccurrykart', :city => 'sanfrancisco', :twitter_id => '23233081'}).categories = [lunch] 
Truck.find_or_create_by_name({:name => 'AmuseBoucheSF', :city => 'sanfrancisco', :twitter_id => '28742966'}).categories = [breakfast] 
Truck.find_or_create_by_name({:name => 'chezspencergo', :city => 'sanfrancisco', :twitter_id => '36159715'}).categories = [french, lunch] 
Truck.find_or_create_by_name({:name => 'RoliRoti', :city => 'sanfrancisco', :twitter_id => '32143933'}).categories = [organic, lunch] 
Truck.find_or_create_by_name({:name => 'tamalelady', :city => 'sanfrancisco', :twitter_id => '40296757'}).categories = [tamales, mexican, lunch] 
Truck.find_or_create_by_name({:name => 'chowdermobile', :city => 'sanfrancisco', :twitter_id => '31574742'}).categories = [soup, seafood, lunch] 
Truck.find_or_create_by_name({:name => 'Onigilly', :city => 'sanfrancisco', :twitter_id => '59358798', :website => 'http://www.onigilly.com'}).categories = [japanese, asian, sushi, lunch] 
Truck.find_or_create_by_name({:name => 'CupkatesTruck', :city => 'sanfrancisco', :twitter_id => '45983922', :website => 'http://www.cupkatesbakery.com'}).categories = [cupcakes, dessert, lunch] 
Truck.find_or_create_by_name({:name => 'CurryUpNow', :city => 'sanfrancisco', :twitter_id => '68867011', :website => 'http://www.curryupnow.com'}).categories = [indian, lunch] 
Truck.find_or_create_by_name({:name => 'Karascupcakes', :city => 'sanfrancisco', :twitter_id => '33122058', :website => 'http://www.karascupcakes.com'}).categories = [cupcakes, dessert, lunch] 
Truck.find_or_create_by_name({:name => 'AdoboHobo', :city => 'sanfrancisco', :twitter_id => '59991967', :website => 'http://www.theadobohobo.com'}).categories = [filipino, asian, dinner] 
Truck.find_or_create_by_name({:name => 'LumpiaCart', :city => 'sanfrancisco', :twitter_id => '54287396', :website => 'http://www.mixsterious.com'}).categories = [filipino, asian, dinner] 
Truck.find_or_create_by_name({:name => 'sfcookies', :city => 'sanfrancisco', :twitter_id => '51272669', :website => 'http://blog.sweetconstructions.com'}).categories = [dessert, dinner] 
Truck.find_or_create_by_name({:name => 'simplechicago', :city => 'chicago', :twitter_id => '173927109', :website => 'http://www.simplechicago.com/'}).categories = [sandwiches,lunch] 
Truck.find_or_create_by_name({:name => 'webakecupcakes', :city => 'chicago', :twitter_id => '71128186', :website => 'http://www.cupcake-gallery.com/'}).categories = [cupcakes, dessert, lunch, dinner] 
Truck.find_or_create_by_name({:name => 'tamalespaceship', :city => 'chicago', :twitter_id => '127625218', :website => 'http://www.facebook.com/tamallispacecharros'}).categories = [tamales, mexican, lunch, dinner] 
Truck.find_or_create_by_name({:name => 'bunpowbuns', :city => 'chicago', :twitter_id => '184280821', :website => 'None'}).categories = [dinner, asian, bars] 
Truck.find_or_create_by_name({:name => 'themoremobile', :city => 'chicago', :twitter_id => '50562651', :website => 'http://www.morecupcakes.com'}).categories = [cupcakes, dessert, lunch] 
Truck.find_or_create_by_name({:name => 'TippingDaCow', :city => 'chicago', :twitter_id => '137817719'}).categories = [dinner, burgers, bars] 