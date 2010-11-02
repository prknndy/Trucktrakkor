// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults



function loadMap(clat, clng, zoom) {

		var zlvl = new Number(zoom);
		
        var clatlng = new google.maps.LatLng(clat, clng);
        
       	var myOptions = { 
        	zoom: zlvl.valueOf(), 
       		center: clatlng, 
        	mapTypeId: google.maps.MapTypeId.ROADMAP
        };
      	var map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
      	
      	return map;
}

function addLocation(name, text, lat, lng, marker, map) {
	
        var shape = {
        	      coord: [1, 1, 1, 32, 48, 32, 48 , 1],
        	      type: 'poly'
        	  };
        	    	
            	
    	
	   //Create infowindow
        var contentString = '<div id="infoWindowTitle">' + name + '</div>';
//if ($("location dist", this).text()) 
	           //contentString = contentString + '<div id="infoWindowTime">' + $("location dist", this).text() +  'mi away</div>';
        contentString = contentString + ' <div id="infoWindowBody">' + text + '</div>';
	        //contentString = contentString + ' <div id="infoWindowTime">' + $("location tweet time", this).text() + '</div>'; 


        var infowindow = new google.maps.InfoWindow({ 
	            content: contentString 
	    });
			// Create image for icon
	        var image = new google.maps.MarkerImage(marker,
	            	new google.maps.Size(48, 32),
	           		new google.maps.Point(0,0),
	            	new google.maps.Point(21, 31));
	      	// Create marker
	        var latlng = new google.maps.LatLng(lat,lng);
	        var marker = new google.maps.Marker({ 
	        	position: latlng,
	        	icon: image,
		        shape: shape, 
	            title: name
	            
	        });  
	        marker.setMap(map);
	        // Set click action on marker
	        google.maps.event.addListener(marker, 'click', function() { 
	            infowindow.open(map, marker); 
	        });

    	
}