require 'xml'

class Location < ActiveRecord::Base
  has_many :tweets
  
  # returns distance from location loc in miles
  def get_dist(loc)
    lat1 = (self.lat.to_f/180)* Math::PI
    lng1 = (self.lng.to_f/180)* Math::PI
    lat2 = (loc.lat.to_f/180)* Math::PI
    lng2 = (loc.lng.to_f/180)* Math::PI
    dLat = lat1 - lat2
    dLng = lng1 - lng2
    e_R = Float(3958.76) #radius of the earth in mi
    a = Math.sin(dLat/2)**2 + Math.cos(lat1) * Math.cos(lat2) * Math.sin(dLng/2)**2
    c = 2 * Math.atan2(Math.sqrt(a),Math.sqrt(1-a))
    (e_R * c).round
  end
  
  # searches text parameter for a valid location in city specified by city parameter
  # returns a location object if one exists
  def Location.valid_location?(text, city)
    
    # Split text into sentences and process seperately
    # assuming !,? or any period after a word with length > 3
    # represents the end of a sentence.
    sentences = text.downcase.gsub(/(\w{1,3})\./, '\1').split(/\.|\?|!/)
    sentences.each do |sentence|
      # For now, ignore sentences that allude to a future date
      next if sentence =~ /monday|tuesday|wednesday|thursday|friday|saturday|sunday|tomorrow/i
      # Check for a street address match
      addr_match = sentence.match(/\d{1,4} ([NnEeSsWw]|[Nn]orth|[Ee]ast|[Ss]outh|[Ww]est)\.? (\w+)/i)
      if (addr_match)
        if (Street.find_by_name_and_city(addr_match[2].capitalize, city))
          our_location = Location.get_location_from_address(addr_match[0], city)
          if our_location
            return our_location
          end
        end
      end  
      # Check for a block match
      block_match = sentence.match(/\d{1,2}00 ([Bb]lock|blc?k) (of)? ([NnEeSsWw]|[Nn]orth|[Ee]ast|[Ss]outh|[Ww]est)\.? (\w+)/i)
      if (block_match)
        if (Street.find_by_name_and_city(block_match[4].capitalize, city))
          our_location = Location.get_location_from_address(block_match[0], city)
          if our_location
            return our_location
          end
        end
      end
      # Split into words and check each one against the street database and location database keywords
      # Once two streets are found, try and find a location, otherwise return nil
      street_matches = []
      sentence.split(/\s+/).each do |w|
        
        location_match = Location.get_location_by_keyword(w, sentence, city)
        if (location_match)
          return location_match
        end
        
        street_match = Street.find_by_name_and_city(w.capitalize, city)
        if (street_match)
          street_matches.push(w)
        end
        
        if (street_matches.length > 1)
          intersection_string = "#{street_matches[0]} and #{street_matches[1]}"
          our_location = Location.get_location_from_address(intersection_string, city)
          if our_location
            return our_location
          end
          nil
        end
      end
    end
    nil
  end
  
  # Searches database for locations with a keyword equal to the input.
  # If any are found, it searches the sentence the keyword was found in
  # for a match with the locations name or a regexp that represents the
  # locations name.
  def Location.get_location_by_keyword(keyword, sentence, city)
    # Pull all locations with same keyword from database
    location_matches = Location.find_all_by_keyword_and_city(keyword, city)
    location_matches.each do |location_match|
      # If the location has a reg_match, return location if it exists in the sentence
      if location_match.reg_match
        if sentence =~ Regexp.new(location_match.reg_match, true)
          return location_match
        end
      # Otherwise, generate a regex from the location's name and try that
      else
        reg_match = Regexp.new(location_match.name, true)
        if sentence =~ reg_match
          return location_match
        end
      end
    end
    nil
  end
  
  # Returns a location object for address if it is valid for city
  # saves object if save is true (default)
  def Location.get_location_from_address(address, city, save=true)
    # TODO: Pull these from the city database
    city_strings = { 'chicago' => ',+Chicago,+IL', 'sanfrancisco' => ',+San+Francisco,+CA', 'newyork' => '+New+York,+NY'}
      
    # Check if this location is already in the database
    our_location = Location.find_by_name_and_city(address,city)
    if our_location
      return our_location
    end
    # Create the address query string by replacing whitespace with '+'s and adding a city, st
    full_address = address.gsub(/\s+/, '+') + city_strings[city]
    # TODO: Add bounds variable
    # Try and geocode the address
    geocode_source = "http://maps.google.com/maps/api/geocode/xml?address=#{full_address}&sensor=false"
    parser = XML::Parser.file(geocode_source)
    doc = parser.parse
    # If successful, create a new location
    if (doc.find_first('status').inner_xml == 'OK')
      location_node = doc.find_first('result').find_first('geometry').find_first('location')
      new_lat = location_node.find_first('lat').inner_xml
      new_lng = location_node.find_first('lng').inner_xml
      our_location = Location.new({:name => address, :city => city, :lat=>new_lat, :lng=>new_lng})
      if save
        our_location.save
      end
      our_location
    else
      nil
    end
  end
  
end
