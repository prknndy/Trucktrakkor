require 'test_helper'

class LocationTest < ActiveSupport::TestCase
  
  test "Find Existing Street Address" do
    test_address = 'MyText'
    city = 'chicago'
    assert(Location.get_location_from_address(test_address, city).valid?)
  end
  
  test "Geolocate Street Address Failure" do
    # This test currently fails due to the way google geolocates:
    # as long as the city is specified, googlemaps will return a valid lat/lng
    # even if the address is bogus.
    test_address = 'Meow and Woof'
    city = 'chicago'
    assert(Location.get_location_from_address(test_address,city).nil?)
  end
  
  test "Geolocate Street Address Success" do
    test_address = 'Clark and Lake'
    city = 'chicago'
    assert(Location.get_location_from_address(test_address, city).valid?)
  end
  
  test "Find Location by Keyword Success - Regex" do
    test_sentence = 'We are heading to merchandise mart'
    test_keyword = 'mart'
    city = 'chicago'
    assert(Location.get_location_by_keyword(test_keyword, test_sentence, city).valid?)
  end
  
  test "Find Location by Keyword Success - NoRegex" do
    test_sentence = 'We are heading to the Aon Center now!'
    test_keyword = 'Aon'
    city = 'chicago'
    assert(Location.get_location_by_keyword(test_keyword, test_sentence, city).valid?)
  end
  
  test "Find Location by Keyword Failure" do
    test_sentence = "We are heading to the kwik e mart."
    test_keyword = 'mart'
    city = 'chicago'
    assert(Location.get_location_by_keyword(test_keyword, test_sentence, city).nil?)
  end
  
  test "Valid Location from Tweet with Keyword Success" do
    tweet_text = "Hello Followers! We are heading to the merch mart. See you soon?"
    city = 'chicago'
    assert(Location.valid_location?(tweet_text, city).name == "Merchandise Mart")
  end
  
  test "Valid Location from Tweet with Intersection Success" do
    tweet_text = "Hello Followers! We are heading to clark and lake. See you soon?"
    city = 'chicago'
    assert(Location.valid_location?(tweet_text, city).valid?)
  end
end
