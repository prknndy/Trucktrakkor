require 'xml'

class Location < ActiveRecord::Base
  has_many :tweets
  
  def get_dist(loc)
    # returns distance from loc in miles
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
  
  def Location.valid_location?(text, city)
    
    # Split text into sentences and process seperately
    sentences = text.downcase.gsub(/(\w{1,3})\./, '\1').split(/\.|\?|!/)
    sentences.each do |sentence|
      # For now, ignore sentences that allude to a future date
      next if sentence =~ /monday|tuesday|wednesday|thursday|friday|saturday|sunday|tomorrow/i
      # Check for a street address match
      addr_match = sentence.match(/\d{1,4} ([NnEeSsWw]|[Nn]orth|[Ee]ast|[Ss]outh|[Ww]est)\.? (\w+)/i)
      if (addr_match)
        if (Street.find_by_name_and_city(addr_match[2].capitalize, city))
          our_location = Location.get_location(addr_match[0], city)
          if our_location
            return our_location
          end
        end
      end  
      # Check for a block match
      block_match = sentence.match(/\d{1,2}00 ([Bb]lock|blc?k) (of)? ([NnEeSsWw]|[Nn]orth|[Ee]ast|[Ss]outh|[Ww]est)\.? (\w+)/i)
      if (block_match)
        if (Street.find_by_name_and_city(block_match[4].capitalize, city))
          our_location = Location.get_location(block_match[0], city)
          if our_location
            return our_location
          end
        end
      end
      # Split into words and check each one against the street database
      # Once two streets are found, try and find a location, otherwise return nil
      # TODO: Add location matching...
      street_matches = []
      sentence.split(/\s+/).each do |w|
        
        street_match = Street.find_by_name_and_city(w.capitalize, city)
        if (street_match)
          street_matches.push(w)
        end
        
        if (street_matches.length > 1)
          intersection_string = "#{street_matches[0]} and #{street_matches[1]}"
          our_location = Location.get_location(intersection_string, city)
          if our_location
            return our_location
          end
          nil
        end
      end
    end
    nil
  end
  
  
  def Location.get_location(address, city, save=true)
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
