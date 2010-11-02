require 'test_helper'

class LocationTest < ActiveSupport::TestCase
  
  test "Find Existing Location-Chicago" do
    test_address = 'MyText'
    city = 'chicago'
    assert(Location.get_location(test_address, city).valid?)
  end
  
  test "Geolocate Address Failure -Chicago" do
    test_address = 'Meow and Woof'
    city = 'chicago'
    assert(Location.get_location(test_address,city).nil?)
  end
  
  test "Geolocate Address Success -Chicago" do
    test_address = 'Clark and Lake'
    city = 'chicago'
    assert(Location.get_location(test_address, city).valid?)
  end
end
