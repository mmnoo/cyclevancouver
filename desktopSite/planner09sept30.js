// JScript File

    var geocoder;
var address;
var textLocation;
var map;
var markerFT;
    var tmpArray        
        function SearchRoute() 
        {
        
        map = new GMap2(document.getElementById("map"));
		map.addMapType(G_PHYSICAL_MAP);
		map.addMapType(G_SATELLITE_3D_MAP);
        map.addControl(new GLargeMapControl());
        map.addControl(new GMapTypeControl());
        map.setCenter(new GLatLng(49.400000, -122.845783),10);
        //map.setCenter(new GLatLng(49.198812, -122.845783),10);
        map.enableScrollWheelZoom();
 
     
        var icon = new GIcon();
        icon.image = "images/bike_light2.png";
        //icon.shadow = "images/shadow.png";
        icon.iconSize = new GSize(8, 8);
        //icon.shadowSize = new GSize(7, 12);
        icon.iconAnchor = new GPoint(5, 5);
        icon.infoWindowAnchor = new GPoint(6, 1);


        // A function to create the marker and set up the event window
        function createMarker(point,infoWin, icon) {
            var marker = new GMarker(point, {icon:icon});
            GEvent.addListener(marker, "click", function() {
            marker.openInfoWindowHtml(infoWin);
            });
            return marker;
        }
		
//
        // Read the data from bike_signal.xml
        GDownloadUrl("bike_signal.xml", function(doc){
            var batch = [];
            var xmlDoc = GXml.parse(doc);
              // obtain the array of markers and loop through it
              var markers = xmlDoc.documentElement.getElementsByTagName("marker");
      
              for (var i = 0; i < markers.length; i++) {
                // obtain the attribues of each marker
                var lat = parseFloat(markers[i].getAttribute("lat"));
                var lng = parseFloat(markers[i].getAttribute("lng"));
                var point = new GLatLng(lat,lng);
                var infoWin = markers[i].getAttribute("infoWin");
                // create the marker
                var marker = createMarker(point, infoWin, icon);
                batch.push(marker);
              }
            var mgr = new GMarkerManager(map, {borderPadding:1});      
            mgr.addMarkers(batch, 13, 17);
            mgr.refresh();
        }); 
		
//MN edits Summer 2009
		function geocodeTo()
		{
		GEvent.addListener(map, "click", getAddress);
		textLocation = "end";
		geocoder = new GClientGeocoder();
		}  
		function geocodeFrom()
		{
		GEvent.clearListeners(map, "click");
		textLocation = "start";
		GEvent.addListener(map, "click", getAddress);
		geocoder = new GClientGeocoder();
		}   


		function getAddress(overlay, latlng)
		{
		  if (latlng != null) 
			{
			address = latlng;
			geocoder.getLocations(latlng, showAddress);
			}
		}

		function showAddress(response)
			{
			  //markerFT.hide();
			  map.clearOverlays();
			  //map.removeOverlay();
			  if (!response || response.Status.code != 200) 
				  {
				alert("Status Code:" + response.Status.code);
				  } 
			  else 
				{
				place = response.Placemark[0];
				point2 = new GLatLng(place.Point.coordinates[1],place.Point.coordinates[0]);
				markerFT = new GMarker(point2);
				map.addOverlay(markerFT);
				if (textLocation == "end"){document.infoForm.addrEnd.value = (place.address);}
				if (textLocation == "start"){document.infoForm.addrStart.value = (place.address);}
				}
			}
	
       

        var reasons=[];
        reasons[G_GEO_SUCCESS]            = "Success";
        reasons[G_GEO_MISSING_ADDRESS]    = "Missing Address: The address was either missing or had no value.";
        reasons[G_GEO_UNKNOWN_ADDRESS]    = "Unknown Address:  No corresponding geographic location could be found for the specified address.";
        reasons[G_GEO_UNAVAILABLE_ADDRESS]= "Unavailable Address:  The geocode for the given address cannot be returned due to legal or contractual reasons.";
        reasons[G_GEO_BAD_KEY]            = "Bad Key: The API key is either invalid or does not match the domain for which it was given";
        reasons[G_GEO_TOO_MANY_QUERIES]   = "Too Many Queries: The daily geocoding quota for this site has been exceeded.";
        reasons[G_GEO_SERVER_ERROR]       = "Server error: The geocoding request could not be successfully processed.";
        document.getElementById("feedback").innerHTML = "";
        document.getElementById("rteSearch").innerHTML = "";
        var addrStart = document.getElementById("addrStart").value;
        var addrEnd = document.getElementById("addrEnd").value;
        var bounds = new GLatLngBounds();
        map.clearOverlays();
        
        var geo = new GClientGeocoder(); 
           
        geo.getLocations(addrStart, function (result1)
        { 

	        if (addrStart == ""){
	            //document.getElementById("feedback").style.fontSize= "small";
	            document.getElementById("feedback").innerHTML = "Start address missing.";
	            return false;
	        }


            // If that was successful
            if (result1.Status.code == G_GEO_SUCCESS) 
            {
            
                // Loop through the results, placing markers
                for (var i=0; i<result1.Placemark.length; i++) 
                {
                     var p1 = result1.Placemark[i].Point.coordinates;
                     var lat1 = p1[1];
                     var lng1 = p1[0];
                    //if not in the GVRD region, then exit;
                    if (lat1 < 49.001949 || lat1>49.473225 || lng1 > -122.358929 || lng1 <-123.320024)
                    {
		                //document.getElementById("feedback").style.width = "200px";
		                //document.getElementById("rtesearch").style.width = "1px";
		                //document.getElementById("feedback").style.fontSize= "smaller";
                        document.getElementById("feedback").innerHTML = "Start address unrecognizable.";
                        return false;}
                    
                    var marker = new GMarker(new GLatLng(lat1,lng1));
                    bounds.extend(new GLatLng(lat1, lng1));
                    map.addOverlay(marker);
                }
            
                               
                //The destination address should also be correct for a route search
                geo.getLocations(addrEnd, function (result2)
                { 

		            if (addrEnd == ""){
		                //document.getElementById("feedback").style.fontSize= "small";
		                document.getElementById("feedback").innerHTML = "Destination address missing.";
		                return false;
		            }

                    // If that was successful
                    if (result2.Status.code == G_GEO_SUCCESS) 
                    {
                        // Loop through the results, placing markers
                        for (var i=0; i<result2.Placemark.length; i++) 
                        {
                            var p2 = result2.Placemark[i].Point.coordinates;
                            var lat2 = p2[1];
                            var lng2 = p2[0];
                            
                            //if not in the GVRD region, then exit;
                            if (lat2 < 49.001949 || lat2 >49.473225 || lng2 > -122.358929 || lng2 <-123.320024)
                            {
			                    //document.getElementById("rtesearch").style.width = "1px";
			                    //document.getElementById("feedback").style.width = "200px";
			                    //document.getElementById("feedback").style.fontSize= "smaller";
                                document.getElementById("feedback").innerHTML = "Address unrecognizable.";
                                return false;}
                            
                            var marker = new GMarker(new GLatLng(lat2, lng2));
                            bounds.extend(new GLatLng(lat2, lng2));
                            map.addOverlay(marker);
                        }
                        
                        // determine the zoom level from the bounds
                        map.setZoom(map.getBoundsZoomLevel(bounds));
                        // determine the centre from the bounds
                        map.setCenter(bounds.getCenter());
                        //ret = RouteService.NodeCoords(34888, 33973, OnComplete, OnTimeOut, OnError);                    
                        //alert(p1[0] + " " + p1[1]);
                        
                        var startTime=new Date();
                        
                        var year = startTime.getFullYear();
                        var month = startTime.getMonth()+1 ;
                        var day = startTime.getDate();
                        var hour = startTime.getHours();
                        var minute = startTime.getMinutes();

                        var txtFile = "_" + year + "." + month + "." + day + "." + hour + "." + minute + ".txt";


                        // request the directions
                        var RouteType = document.forms.infoForm.RouteCategory.selectedIndex;
                        var RoutePreference = document.forms.infoForm.RoutePreference.selectedIndex;
                        var RouteSpeed = document.forms.infoForm.Speed.value;
                        var RouteSlope = document.forms.infoForm.Slope.value;
                        var VerifySpeed = /^ *[0-9]+ *$/.test(RouteSpeed);
                        var VerifySlope = /^ *[0-9]+ *$/.test(RouteSlope);
                        
                        if(VerifySpeed !=1){ 
                            document.getElementById("feedback").innerHTML= "Incorrect speed.";
                            return false;
                        }

                        if(VerifySlope !=1){ 
                            document.getElementById("feedback").innerHTML= "Incorrect grade.";
                            return false;
                        }
                        
                        //////////////////////////////////////////////////                            
                        //////////////////////////////////////////////////
                        function OnComplete(arg) {

                            var a=Math.floor((new Date()-startTime)/100)/10;
                            if (a%1==0) a+=".0";
                            //document.getElementById("feedback").style.fontSize= "small";
                            //document.getElementById("rtesearch").style.width = "1px";
                            //document.getElementById("feedback").style.width = "200px";
                            document.getElementById("feedback").innerHTML= "Time spent: " + a + " seconds.";
							
                            //MN edits Summer 2009
                            tmpArray = arg.split("?");
                            var nodes = tmpArray[0].split(" ");
                            document.getElementById("LeftPanel").style.fontSize= "13px";
                            if (tmpArray[0] == "No_path") 
								{
                                document.getElementById("LeftPanel").innerHTML = "<b>No direct route. Please try: </b><br> (a) increasing the maximum slope restriction, <br> (b) selecting 'Major Roads Included' for the route type, or <br>(c) switching start and end address.";
								}
							else
								{
								
                                document.getElementById("LeftPanel").innerHTML = (tmpArray[1] +tmpArray[2] );	
								}
							//</MN>
							
                            if(!isNaN(nodes[0])){
                            //document.getElementById("feedback").style.fontSize= "small";
                            //document.getElementById("rtesearch").style.width = "1px";
                            //document.getElementById("feedback").style.width = "200px";
                            document.getElementById("feedback").innerHTML= "No direct route.";
                                //alert("No direct route");
                                return false;
                            }
                            var nodesCount = nodes.length;
                            if (nodesCount >0){ //prevent first webservice call to run this code.
                                document.getElementById("rteSearch").innerHTML = "";
                                //document.getElementById("GPSOutPut").innerHTML = "<a href = 'Text/'" + txtFile + "> Route Coords </a>";
                                //document.getElementById("GPSOutPut").innerHTML = "<a target = '_blink' href = http://cyclevancouver.ubc.ca/Text/" + txtFile + "> Route Coords </a>";
                                                                
                                var polyline;
                                var color;
                                var latlng1, latlng2;
                               for (var i = 0; i < nodesCount-1; i++) {
                                    latlng1 = nodes[i].split("|");
                                    latlng2 = nodes[i+1].split("|");
                                    if(latlng1[2] == 1){
                                        color = "#0058c9";
                                    }
                                    else if (latlng1[2]==2){
                                        color = "#00FFFE";
                                    }
                                    else if (latlng1[2]==3){
                                        color = "#00EA48";
                                    }
                                    else if (latlng1[2]==4){
                                        color = "#ffbe00";//"#6F3198";//"#Aa0000";//
                                    }
                                    else if (latlng1[2]==5){
                                        color = "#E20000";
                                    }
                                    
                                    polyline = new GPolyline([new GLatLng(latlng1[0], latlng1[1]), new GLatLng(latlng2[0], latlng2[1])], color, 4, 0.8);
                                    map.addOverlay(polyline); 
								//MN edits Summer 2009
								//if the george Massey tunnel is in the route's map extents, then show its info window
								// George Massey tunnel coords: 49.121035, -123.075083636
								var bounds = map.getBounds();
								var southWest = bounds.getSouthWest();
								var northEast = bounds.getNorthEast();
								var maxLat = northEast.lat();
								var maxLng = southWest.lng();
								var minLng = northEast.lng();
								var minLat = southWest.lat();
								// could use if statement with contents of tmpArray[2]? that way only if the route is within a certain distance of the george massey tunnel, the  pop up window displays....
								if (49.121035 < maxLat && 49.121035 > minLat && -123.075083636 > maxLng && -123.075083636 < minLng) 
									{
									map.openInfoWindow((new GLatLng(49.121035, -123.075083636)), "<a href='http://www.th.gov.bc.ca/popular-topics/driver_info/route-info/massey/massey.htm' target='_blank'>George Massey Tunnel Shuttle Info</a>");	
									//GLog.write(maxLat + "," + maxLng + "," + minLat + "," + minLng);
									}									
                                }
                            }
                            
                            //alert(latlng);
                        }    
                        //////////////////////////////////////////////////                            

                         function OnTimeOut(arg) {
                            //document.getElementById("feedback").style.fontSize= "small";
                            //document.getElementById("rtesearch").style.width = "1px";
                            //document.getElementById("feedback").style.width = "200px";
                            document.getElementById("feedback").innerHTML= "Time out encountered.";
                            //alert("TimeOut encountered.");
                        }
                        //////////////////////////////////////////////////                            
                        function OnError(arg) {
                            //document.getElementById("feedback").style.fontSize= "small";
                            //document.getElementById("rtesearch").style.width = "1px";
                            //document.getElementById("feedback").style.width = "200px";
                            document.getElementById("feedback").innerHTML= "Error with Server.";
                            //alert("Error encountered.");
                        }
                        //////////////////////////////////////////////////                            
                        //////////////////////////////////////////////////                            
                        
                        //if( RouteType == 1 ){
                        //    document.getElementById("LeftPanel").innerHTML="";
                        //    //document.getElementById("LeftPanel").style.fontSize= "small";
                        //    var gdir=new GDirections(map, document.getElementById("LeftPanel"));
                        //    gdir.load("from: "+addrStart+" to: "+addrEnd);
                        //    return false;
                        //}
                        //else if(RouteType == 0)
                        //{
                        //    //It only goes to database to do the search if both addresses are correct.
			            //    //document.getElementById("feedback").style.width = "1px";
			            //    //document.getElementById("rtesearch").style.width = "200px";
			            //    //document.getElementById("rteSearch").style.fontSize = "smaller";
                        //    document.getElementById("rteSearch").innerHTML = "Searching... <img src='images/indicator.gif'>";
                        //    ret = RouteService.NodeCoords(RoutePreference, RouteSpeed, RouteSlope, p1[0], p1[1], p2[0], p2[1], OnComplete, OnTimeOut, OnError);
                        //}
                        
                        document.getElementById("rteSearch").innerHTML = "Searching... <img src='images/indicator.gif' width='20' height='20'>";
                        ret = RouteService.NodeCoords(RouteType, RoutePreference, RouteSpeed, RouteSlope, p1[0], p1[1], p2[0], p2[1], txtFile, OnComplete, OnTimeOut, OnError);
                        
                    }
                    // Show the error status
                    else 
                    {
                        var reason="Code "+result2.Status.code;
                        if (reasons[result2.Status.code]) 
                        {
                            reason = reasons[result2.Status.code];
                        } 
		                //document.getElementById("feedback").style.fontSize= "small";
		                //document.getElementById("rtesearch").style.width = "1px";
		                //document.getElementById("feedback").style.width = "200px";
                        document.getElementById("feedback").innerHTML= "Destination address unrecognizable.";
                        //alert('Could not find destination address "'+addrEnd+ '" ' + reason);
                        return false;
                    }
                 });             
                            
                }
                //  Decode the error status
                else 
                {
		            //document.getElementById("feedback").style.fontSize= "small";
		            //document.getElementById("rtesearch").style.width = "1px";
		            //document.getElementById("feedback").style.width = "200px";
                    document.getElementById("feedback").innerHTML= "Start address unrecognizable.";
                    //alert('Could not find starting address "'+addrStart+ '" ' + reason);
                    return false;
                }
             });
        
		}
  
  
  
    
