<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CVStreetView.aspx.cs" Inherits="Default3" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml">
<head>
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" /> <!-- this replaces line 8 until IE 8 works out ist bug where map click markers dont show up in the right location-->
    <!--<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>-->
    <title>Cycling Route Planner</title> 
    <script src="http://maps.google.com/maps?file=api&amp;v=2.x&amp;key=ABQIAAAAYD5sxaBVp3byjEakhpZcxRRPbZ4hl9O3TrKJpvAAEYuJj_Ia7xScTAY86n0ETCo97gtrAOMV2pbuZA&sensor=false" type="text/javascript"></script>
<script type="text/javascript">




    document.write('<script type="text/javascript" src="http://gmaps-utility-library-dev.googlecode.com/svn/tags/markermanager/1.1/src/markermanager' + (document.location.search.indexOf('packed') > -1 ? '_packed' : '') + '.js"><' + '/script>');
        </script>


<script type="text/javascript">
    
var geocoder;
var address;
var textLocation;
var map;
var markerFT;
var printMap;
var alternate;
var designated;
var dinMark;
var twoBridgeMark;
var NO2;
var green;
//var slope;
var noBikes;
var other;
var mgr;
var trucks;
var fountains;
var schools;
var cmtyCntrs;
var ST;
var STstn;

    function PageLoad(){
        
        if (GBrowserIsCompatible()) {
            

            var mapOptions = {
                googleBarOptions: {
                    style: "new"
                }
            }


            map = new GMap2(document.getElementById("map"), mapOptions);

                
            //connect kml
            var url_end = "?nocache=" + (new Date()).valueOf();
            var schoolsKML = "http://www.cyclevancouver.ubc.ca/KML/CoV_Schools.kml"; //+ url_end;
            var cmtyCntrsKML = "http://www.cyclevancouver.ubc.ca/KML/Cov_CmtyCEnters.kml";  //+ url_end;
            var fountainsKML = "http://www.cyclevancouver.ubc.ca/KML/CoV_DrinkingFountains.kml";  //+ url_end;
            var trucksKML = "http://www.cyclevancouver.ubc.ca/KML/CoV_TruckRoutes.kml";  //+ url_end;
            var alternateKML = "http://www.cyclevancouver.ubc.ca/KML/alternate.kml";  //+ url_end;
            var designatedKML = "http://www.cyclevancouver.ubc.ca/KML/designated.kml";  //+ url_end;
            var noBikesKML = "http://www.cyclevancouver.ubc.ca/KML/NoBikes.kml";  //+ url_end;
            var otherKML = "http://www.cyclevancouver.ubc.ca/KML/Other.kml";  //+ url_end;
            var stKML = "http://www.cyclevancouver.ubc.ca/KML/Skytrain.kml";  //+ url_end
            var ststnKML = "http://www.cyclevancouver.ubc.ca/KML/SkytrainStations.kml";  //+ url_end; ;
            
            fountains = new GGeoXml(fountainsKML);
            trucks = new GGeoXml(trucksKML);
            alternate = new GGeoXml(alternateKML);
            designated = new GGeoXml(designatedKML);
            noBikes = new GGeoXml(noBikesKML);
            other = new GGeoXml(otherKML);
            schools = new GGeoXml(schoolsKML);
            cmtyCntrs = new GGeoXml(cmtyCntrsKML);
            ST = new GGeoXml(stKML);
            STstn = new GGeoXml(ststnKML);
			
			map.addMapType(G_PHYSICAL_MAP); 
			
            map.addControl(new GLargeMapControl());
            map.addControl(new GMapTypeControl());
            map.setCenter(new GLatLng(49.323297, -123.006936),12);
            //map.setCenter(new GLatLng(49.198812, -122.845783),10);
            map.enableScrollWheelZoom();
            map.enableGoogleBar();
            //map.addMapType(G_SATELLITE_3D_MAP); //to date(sept 2009), this conflicts with the google search bar


            
            //enable marker manager for signals
            mgr = new MarkerManager(map);

                        
			//test when streetview is avail in canada
            //var svOverlay = new GStreetviewOverlay();
            //map.addOverlay(svOverlay);

			//overlay rasters
			var no2SW = new GLatLng(48.9996544113, -123.277029482);
			var no2NE = new GLatLng(49.3739046825, -122.20622684);

			NO2 = new GGroundOverlay("http://cyclevancouver.ubc.ca/kml/jpegs/NO2.png", new GLatLngBounds(no2SW, no2NE));
			////

			var greenSW = new GLatLng(48.9953654304, -123.291324765);
			var greenNE = new GLatLng(49.3832462103, -122.387552508);

			green = new GGroundOverlay("http://cyclevancouver.ubc.ca/kml/jpegs/green.png", new GLatLngBounds(greenSW, greenNE));
			////
			//var slopeSW = new GLatLng(48.9993297052, -123.277342442);
			//var slopeNE = new GLatLng(49.3740263458, -122.20620607);

			//slope = new GGroundOverlay("http://cyclevancouver.ubc.ca/kml/jpegs/slope.png", new GLatLngBounds(slopeSW, slopeNE));

			
			
        
        }//end function pageload
    
        // display a warning if the browser was not compatible
        else {
            document.getElementById("feedback").innerHTML= "Browser not compatible.";
            //alert("Sorry, the Google Maps API is not compatible with this browser");
        }
    
    
 
        //window.moveTo(0,0);
        //window.resizeTo(screen.availWidth, screen.availHeight);

        SetMapDimension();
        RouteService.Service_Initialization();
        document.getElementById("LeftPanel").style.fontSize= "small";
        document.getElementById("LeftPanel").innerHTML=
			"<div style='font-size:12px'> <b>Data Sources:</b></div><hr />Translink: <a href='CyclingRouteData.html'target='_blank' class='style3' onClick='showPopup2(this.href);return(false);'>cycling route data</a><br><br>Google Maps:underlying road network and images for display<br><br>DMTI Spatial:<a href='DEM.html'target='_blank' class='style3' onClick='showPopup2(this.href);return(false);'>digital elevation data</a><br><br>United States Geological Survey:<a href='LandCovVeg.html'target='_blank' class='style3' onClick='showPopup2(this.href);return(false);'>Land cover data for vegetation classification </a><br><br>Border Air Quality Study team:<a href='PolVeg.html'target='_blank' class='style3' onClick='showPopup2(this.href);return(false);'>traffic pollution</a> and vegetation classification results<br><br>Developed by the <a href='http://www.cher.ubc.ca/cyclingincities/default.htm' target='_blank' class='style3'>Cycling in Cities</a> project team at the University of British Columbia, in cooperation with the following agencies: </HR><br><br><a href='http://ubc.ca/'target='_blank'><CENTER><img src='Logos/ubc_coat_of_arms11154.gif' alt='University of British Columbia' width='40' border='0'></CENTER><br><a href='http://vancouver.ca'target='_blank'><CENTER><img src='Logos/CoV.gif' alt='City of Vancouver' width='105' border='0'></CENTER><br><a href='http://www.translink.ca/'target='_blank'><CENTER><img src='Logos/logo-translink-over.ashx.gif'alt='Translink' width='105' border='0'></CENTER><br></a><a href='http://www.heartandstroke.com'target='_blank'><CENTER><img src='Logos/HSFClogo.jpg'alt='Heart and Stroke Foundation' width='140' border='0' ></CENTER></a><br><a href='http://www.cihr-irsc.gc.ca/e/193.html'target='_blank'><CENTER><img src='Logos/CIHRlogo2.jpg'alt='Canadian Institute of Health Research' width='105' border='0'></CENTER><br><br><B><a href='Documentation_Disclaimer.html'target='_blank' class='style3'>Please read our disclaimer and documentation</b></a></a>";
        //document.getElementById("RightPanel").innerHTML =
           // " <form id = 'frmToggle' onsubmit='toggleLayers(); return false' name='frmToggle' style='font-family: 'Trebuchet MS'; font-size: 12px;'> <div style='text-align: center; font-size: 14px; font-weight: bold; color: #074379;'>Add data to the map!</div><hr /> <div style='text-align: center; font-weight: bold;'>Olympic Layers </div><hr />  <input id='chkParking' align='top'  name='chkParking' type='checkbox'  checked='checked'/>Bike Parking <br /> <input id='chkOlympVenues' align='top'  name='chkOlympVenues' type='checkbox' checked='checked' />Olympic Venues <br /> <input id='chkRdClosure' align='top'  name='chkRdClosure' type='checkbox' checked='checked'/>Olympic Road Closures <br /> <input id='chkOLane' align='top'  name='chkOLane' type='checkbox' checked='checked'/>Olympic Lanes (no biking!) <br />  <hr /> <div style='text-align: center; font-weight: bold;'>Cycling Layers <hr /></div> <div style='font-weight: normal'> <input id='chkDesignated' align='top'  name='chkDesignated' type='checkbox'/>Designated Bike Routes<br /><input id='chkAlternate' align='top'  name='chkAlternate' type='checkbox'/>'Alternate' Bike Routes<br /><input id='radNO2' type='radio' name='rasters' />Air Pollution Image<br /><input id='radGreen' type='radio' name='rasters' />Vegetation Image<br /><input id='radSlope' type='radio' name='rasters' />Slope Image</div><hr /><div style='text-align: center; font-weight: bold;  '><a href='/legend.html' onclick='showPopup(this.href);return(false);' font-size: 14px; >Legend</a></div><hr /><div style='text-align: center'><a href='javascript:fcnClearAll()' style='font-weight: bold; font-size: 10px;' >Clear Selection</a><br /><br /><input id='btnToggle' type='submit' value='Update Layers'/></div></form>";
    }


    function SetMapDimension(){

        var bodyWidth, bodyHeight;
        var bodyWidth2, bodyHeight2;
        if (typeof( window.innerWidth ) == 'number')
        {
            //Non-IE
            //bodyWidth = window.innerWidth;
            bodyHeight = window.innerHeight;
        }
        else if (document.documentElement && ( document.documentElement.clientWidth || document.documentElement.clientHeight ) ) 
        {
            //IE 6+ in 'standards compliant mode'
            //bodyWidth = document.documentElement.clientWidth;
            bodyHeight = document.documentElement.clientHeight;        
        }
        else if (document.body && ( document.body.clientWidth || document.body.clientHeight ) ) 
        {
	        //bodyWidth = document.body.clientWidth;
	        bodyHeight = document.body.clientHeight;
        }
        
        //bodyWidth2 = bodyWidth - 150;
        bodyHeight2 = bodyHeight -200;
        document.getElementById("map").style.height= bodyHeight2 + "px";
        //document.getElementById("map").style.width= bodyWidth2 + "px";
        document.getElementById("LeftPanel").style.height = bodyHeight2 + "px";
        document.getElementById("RightPanel").style.height = bodyHeight2 + "px";
		map.checkResize();

    }


//    function setOption(form, index) {
//      for (var i = 0; i < form.RoutePreference.length; i++) {
//        form.RoutePreference.options[i].text = "";
//      }

//      if (index == 0) {
//        form.RoutePreference.options[0].text = "Restricted Maximum Slope";
//        form.RoutePreference.options[1].text = "Least Traffic Pollution";
//        form.RoutePreference.options[2].text = "Least Elevation Gain";
//        form.RoutePreference.options[3].text = "Most Vegetated Route";
//        form.RoutePreference.options[4].text = "Shortest Path Route";
//      }
//      else if (index == 1) {
//        form.RoutePreference.options[0].text = "Restricted Maximum Slope";
//        form.RoutePreference.options[1].text = "Least Traffic Pollution";
//        form.RoutePreference.options[2].text = "Least Elevation Gain";
//        form.RoutePreference.options[3].text = "Most Vegetated Route";
//        form.RoutePreference.options[4].text = "Shortest Path Route";        
//      }
//      form.RoutePreference.selectedIndex = 0;
//      setVisibility(0);
//    }


    function setVisibility(index)
    {
        if( index == 0)
        {
            if (document.all){
                document.all["Slope"].style.visibility= "visible";
                document.all["slopeTxt"].style.visibility= "visible";
                }
            else if (document.layers){
                document.layers["Slope"].visibility= "show";
                document.layers["slopeTxt"].visibility= "show";
            }
            else if (document.getElementById) {
                document.getElementById("Slope").style.display = "block";
                document.getElementById("slopeTxt").style.display = "block";
                }
        }
        else
        {
            if (document.all){
                document.all["Slope"].style.visibility= "hidden";
                document.all["slopeTxt"].style.visibility= "hidden";
                }
            else if (document.layers){
                document.layers["Slope"].visibility= "hide";
                document.layers["slopeTxt"].visibility= "hide";
            }
            else if (document.getElementById) {
                document.getElementById("Slope").style.display = "none";
                document.getElementById("slopeTxt").style.display = "none";
                }
        }
    
    }

    var state = "visible";
    function ShowHideLeftPanel(layer_ref) {
        if (state == "visible") {
            state = "hidden";
            document.getElementById("LeftCell").width = "1px";
            document.getElementById(layer_ref).style.width="1px";
            document.getElementById("HideShowToggle").src="images/show-arrowOrange.png";                        
        }
        else {
            state = "visible";
            document.getElementById("LeftCell").width = "200px";
            document.getElementById(layer_ref).style.width="200px";            
            document.getElementById("HideShowToggle").src="images/hide-arrowOrange.png";                        
        }
        if (document.all) { //IS IE 4 or 5 (or 6 beta)
            eval( "document.all." + layer_ref + ".style.visibility = state");
        }
        if (document.layers) { //IS NETSCAPE 4 or below
            document.layers[layer_ref].visibility = state;
        }
        if (document.getElementById && !document.all) {
            var panelID = document.getElementById(layer_ref);
            panelID.style.visibility = state;
        }
    }
    function ShowHideRightPanel() {
        if (state == "visible") {
            state = "hidden";
            //document.getElementById("RightPanel").style.visibility = "hidden";
            document.getElementById("HideShowToggle2").src = "images/hide-arrowOrange.png";
            document.getElementById("RightPanel").style.display = "none"
            document.getElementById("RightPanel").style.overflow = "hidden";
            document.getElementById("RightCell").style.width = "1px";
            document.getElementById(layer_ref).style.width = "1px";
            
        }
        else {
            state = "visible";
            document.getElementById("HideShowToggle2").src = "images/show-arrowOrange.png";
            //document.getElementById("RightPanel").style.visibility = "visable";
            document.getElementById("RightPanel").style.display = "block"
            document.getElementById("RightPanel").style.overflow = "auto";
            document.getElementById("RightCell").style.width = "185px";
            document.getElementById(layer_ref).style.width = "185px";
            document.getElementById("HideShowToggle2").src = "images/show-arrow.png";
           
            
        }
        if (document.all) { //IS IE 4 or 5 (or 6 beta)
            eval("document.all." + layer_ref + ".style.visibility = state");
            
        }
        if (document.layers) { //IS NETSCAPE 4 or below
            document.layers[layer_ref].visibility = state;
        }
        if (document.getElementById && !document.all) {
            var panelID = document.getElementById(layer_ref);
            panelID.style.visibility = state;
        }
    }

    function changeCur(el)
    {
        el.style.cursor = 'pointer';
        el.onmouseout = function()
        {
            el.style.cursor = 'default';
        }
    }


    function FlipText()
    {
        var tmpTxt;
        tmpTxt = document.infoForm.addrStart.value;
        document.infoForm.addrStart.value = document.infoForm.addrEnd.value;
        document.infoForm.addrEnd.value = tmpTxt;
    }
    
    
    
function showPopup(url)
	 {
		newwindow=window.open(url,' ','height=550,width=400,top=200,left=600,resizable');
		if (window.focus) {newwindow.focus()}
	 }
function showPopup2(url)
	 {
		newwindow=window.open(url,'Data Source','height=550,width=550,top=200,left=600,resizable');
		if (window.focus) {newwindow.focus()}
	 }
function showPopup3(url)
	{
		window.open (url, "What's New?", 'height=700,width=999,scrollbars=yes,resizable=yes');
		return false;
}
function showPopup4(url) {
    newwindow = window.open(url, ' ', 'height=675,width=400,top=200,left=600,resizable');
    if (window.focus) { newwindow.focus() }
}

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
	  //map.removeOverlay();
	  map.clearOverlays();
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
	
function showGPSWindow()
	{
		var disp_setting="toolbar=yes,location=no,directories=yes,menubar=yes,"; 
			disp_setting+="scrollbars=yes,width=650, height=600, left=100, top=25"; 
		var content_vlue = tmpArray[3]; 
	  
		var docprint=window.open("","",disp_setting); 
			docprint.document.open(); 
			docprint.document.write('<html><head><title>Cycling Route Suggestion</title>'); 
			docprint.document.write('</head><body><left>');          
			docprint.document.write(content_vlue);          
			docprint.document.write('</left></body></html>'); 
			docprint.document.close(); 
			docprint.focus();	
	}

	function addSignals() {
	    var icon = new GIcon();
	    icon.image = "http://labs.google.com/ridefinder/images/mm_20_purple.png";
	    //icon.shadow = ""http://maps.google.com/mapfiles/ms/micons/lightblue.shadow.png"";
	    icon.iconSize = new GSize(8, 15);
	    //icon.shadowSize = new GSize(7, 12);
	    icon.iconAnchor = new GPoint(4, 15);
	    icon.infoWindowAnchor = new GPoint(6, 1);


	    // A function to create the marker and set up the event window for cyclist controlled crossings
	    function createMarker(point, infoWin, icon) {
	        var marker = new GMarker(point, { icon: icon });
	        GEvent.addListener(marker, "click", function() {
	            marker.openInfoWindowHtml(infoWin);
	        });
	        return marker;
	    }

	    //
	    // Read the data from bike_signal.xml
	    GDownloadUrl("bike_signal.xml", function(doc) {
	        var batch = [];
	        var xmlDoc = GXml.parse(doc);
	        // obtain the array of markers and loop through it
	        var markers = xmlDoc.documentElement.getElementsByTagName("marker");

	        for (var i = 0; i < markers.length; i++) {
	            // obtain the attribues of each marker
	            var lat = parseFloat(markers[i].getAttribute("lat"));
	            var lng = parseFloat(markers[i].getAttribute("lng"));
	            var point = new GLatLng(lat, lng);
	            var infoWin = markers[i].getAttribute("infoWin");
	            // create the marker
	            var marker = createMarker(point, infoWin, icon);
	            batch.push(marker);
	        }
	        
	        mgr.addMarkers(batch, 0, 17);
	        mgr.refresh();

	    }); 
	}
	function toggleLayers() {
	 
        if (document.frmToggle.chkAlternate.checked == true){
				map.removeOverlay(alternate);
                map.addOverlay(alternate);
            }
        if (document.frmToggle.chkAlternate.checked == false){
                map.removeOverlay(alternate);
            }
        if (document.frmToggle.chkDesignated.checked == true){
                map.removeOverlay(designated);
				map.addOverlay(designated);
            }
        if (document.frmToggle.chkDesignated.checked == false){
                map.removeOverlay(designated);
            }
        if (document.frmToggle.chkNoBikes.checked == true) {
                map.addOverlay(noBikes);
            }
        if (document.frmToggle.chkNoBikes.checked == false) {
                map.removeOverlay(noBikes);
            }
        if (document.frmToggle.chkOther.checked == true) {
                map.addOverlay(other);
            }
        if (document.frmToggle.chkOther.checked == false) {
                map.removeOverlay(other);
            }
        if (document.frmToggle.chkSignals.checked == true)
            {
                addSignals();
            }
        if (document.frmToggle.chkSignals.checked == false) {
                mgr.clearMarkers();
                
            }
        if (document.frmToggle.radNO2.checked == true){
                map.addOverlay(NO2);
            }
        if (document.frmToggle.radNO2.checked == false) 
            {
                map.removeOverlay(NO2);
            }
        if (document.frmToggle.radGreen.checked == true){
                map.addOverlay(green);
            }
        if (document.frmToggle.radGreen.checked == false){
                map.removeOverlay(green);
            }
        //if (document.frmToggle.radSlope.checked == true){
           //     map.addOverlay(slope);
           // }
        //if (document.frmToggle.radSlope.checked == false){
           //     map.removeOverlay(slope);
           // }
        if (document.frmToggle.chkTrucks.checked == true) {
                map.addOverlay(trucks);
            }
        if (document.frmToggle.chkTrucks.checked == false) {
                map.removeOverlay(trucks);
            }
        if (document.frmToggle.chkFountains.checked == true) {
                map.addOverlay(fountains);
            }
        if (document.frmToggle.chkFountains.checked == false) {
                map.removeOverlay(fountains);
            }
        if (document.frmToggle.chkSchools.checked == true) {
                map.addOverlay(schools);
            }
        if (document.frmToggle.chkSchools.checked == false) {
                map.removeOverlay(schools);
            }
        if (document.frmToggle.chkCmtyCntrs.checked == true) {
                map.addOverlay(cmtyCntrs);
            }
        if (document.frmToggle.chkCmtyCntrs.checked == false) {
                map.removeOverlay(cmtyCntrs);
            }
            if (document.frmToggle.chkST.checked == true) {
                map.addOverlay(ST);
            }
            if (document.frmToggle.chkST.checked == false) {
                map.removeOverlay(ST);
            }
            if (document.frmToggle.chkSTstn.checked == true) {
                map.addOverlay(STstn);
            }
            if (document.frmToggle.chkSTstn.checked == false) {
                map.removeOverlay(STstn);
            } 
         
	}
	function fcnClearAll() {
	        document.frmToggle.chkST.checked = false;
	        document.frmToggle.chkSTstn.checked = false;
	        document.frmToggle.chkSchools.checked = false;
	        document.frmToggle.chkCmtyCntrs.checked = false;
	        document.frmToggle.chkFountains.checked = false;
	        document.frmToggle.chkTrucks.checked = false;
	        document.frmToggle.chkSignals.checked = false;
	        document.frmToggle.chkOther.checked = false;
	        document.frmToggle.chkNoBikes.checked = false;
	        //document.frmToggle.radSlope.checked = false;
	        document.frmToggle.radGreen.checked = false;
	        document.frmToggle.radNO2.checked = false;
	        document.frmToggle.chkDesignated.checked = false;
	        document.frmToggle.chkAlternate.checked = false;
	        //document.frmToggle.chkOLane.checked = false;
	        //document.frmToggle.chkParking.checked = false;
	        //document.frmToggle.chkRdClosure.checked = false;
	        //document.frmToggle.chkOlympVenues.checked = false;
	        //document.frmToggle.chkClear.checked = false;


	    }
	    var fenwayPark = new GLatLng(42.345573, -71.098326);
	    panoramaOptions = { latlng: fenwayPark };
	    myPano = new GStreetviewPanorama(document.getElementById("pano"), panoramaOptions);
	    GEvent.addListener(myPano, "error", handleNoFlash);

	    function handleNoFlash(errorCode) {
	        if (errorCode == 603) {
	            alert("Error: Flash doesn't appear to be supported by your browser");
	            return;
	        }
	    }  		
  
 </script>

<script type="text/javascript" src ="plannerkml.js"></script>


<style type="text/css">
<!--
.style4 {
	font-size: larger;
	font-weight: normal;
	font-family: "trebuchet MS";
		}
body,td,th {
	font-family: Trebuchet MS, Geneva, Verdana, Arial;
	color: #000000;
}
.style13 {
	font-size: small;
	font-weight: bold;
	
}
.style14 {color: #999999}
.style17 {
	font-size: 9pt;
	color: #808080;
}
.style19 {font-size: 9pt}
.style20 {font-family: "trebuchet MS"}
a:link {
	color: #166BBA;
}
a:visited {
	color: #166BBA;
}

    .style22
    {
        width: 648px;
    }

--> 
</style>
</head>
<body onload = "PageLoad()" onunload="GUnload()" topmargin = "5px" scroll ="no">


 <Table width ="100%">
<tr style ="padding: 0, 0, 0, 0" width ="100%">
<td width ="100%" colspan="5" class="style4" style ="padding: 0, 0, 0, 0">
    <form id="infoForm" name = "infoForm" onsubmit="SearchRoute(); return false" style="margin-bottom:0;" > 
      <table width="100%" align ="left" style ="padding: 0, 0, 0, 0" id="TABLE1" onclick="return TABLE1_onclick()">
        <tr style ="padding: 0, 0, 0, 0" align ="left" width ="200px">
          <!--<th rowspan = 4 align ="left" width ="190" > <img style="padding:0px 0px 0px 0px" src = "images/cycling.png"/> </th>-->
		  <th rowspan = 4 align ="left" width ="190" > <img style="padding:0px 0px 0px 0px" width="205"  src = "images/cycling7.png"/> </th>
          <td style="font-size:12px; height:8px; text-align:bottom;"><b>From Address: </b> <INPUT TYPE='button' Value='get from map click' onClick='geocodeFrom()'><!--<a href=''onclick='geocodeFrom();return(false);'>Get from clicking on the map</a>--></td></td>
          <td></td>
          <td style="font-size:12px"><b>To Address: </b><INPUT TYPE='button' Value='get from map click' onClick='geocodeTo()'><!--<a href=''onclick='geocodeTo();return(false);'>Get from clicking on the map</a>--></td>
          <td align= bottom style="font-size:12px"><b>Speed</b> (km/hr)<b>:</b></td>
          <td colspan="3" align= bottom style="font-size:12px"><a href='AddressInfo.html' onclick='showPopup(this.href);return(false);'>Address Formatting Info</a> </td> <!--<label id="GPSOutPut" style="color:Red; font-size:12px"></label>-->   
		  
        </tr>
        <tr>
          <td width ="175"><input name="addrStart" type="text" id="addrStart" style="width: 273px" value="105 Commercial, Vancouver"/></td>
          <td width="32" align ="center"><div align="left"><img src="images/ddirflip.gif" width="20" onclick="FlipText()" onmouseover="changeCur(this)" /></div></td>
          <td width ="175"><input name="addrEnd" type="text" id="addrEnd" style="width: 273px" value="Van Dusen Botanical Gardens, Vancouver" /></td>
          <td width ="75"><input id="Speed" name ="Speed" type="text" value="15" style="width: 80px"/></td>
          <td colspan ="4" class="style22"><input name="submit" type="submit" value="Get Directions" onsubmit="SearchRoute();"/>
              <span class="style19">
              </span>
              <!--<a href="AddressInfo.html" target="_blank" class="style3">Address Formatting Info Window</a>/-->          </td>
        </tr>
        <tr style ="padding: 0, 0, 0, 0" height="8px">
          <td style="font-size:12px;"><b>Route Type:</b></td>
          <td style="height: 6px"></td>
          <td style="font-size:12px;"><b>Preference:</b></td>
		  <td style="font-size:12px;" ><label id="slopeTxt" style="display: none"><b>Max. Slope </b>(%)<b>: </b></label></td>
        </tr>
        <tr height="10px">
          <td><select id="RouteCategory" name = "RouteCategory"  style="font-size:14px;">
              <option selected="selected">Designated + Alternate Cycling Roads</option>
              <option>Major Roads Included</option>
            </select>          
			</td>
		  <td></td>
          <td><select id="RoutePreference" name = "RoutePreference" onchange="setVisibility(this.selectedIndex)" style="font-size:14px;"><!-- this bit went into the RoutePreference drop box, who knows why: onchange="setOption(this.form, this.selectedIndex)"-->
                        <option>Restricted Maximum Slope</option>
                        <option>Least Traffic Pollution</option>
                        <option>Least Elevation Gain</option>
                        <option>Most Vegetated Route</option>
                        <option selected="selected">Shortest Path Route</option>
              </select>          
	  </td>
	  
          <td><input id="Slope" name = "Slope" type="text" value="10" style="width: 80px; display: none"/></td>
          <td width="254" height="8px"><b><label id="rteSearch" style="font-size:13px; width:1px;" ></label></b></td>
          <td width="367" height="8px"><label id="feedback" style="color:Red; font-size:10px; width: 200px"></label></td>
        </tr>
        <tr height="2px" style="padding:0 0 0 0">
          <td colspan ="7" style="padding:0 0 0 0; height: 1px;"><hr width ="100%" style=" line-height:1; line-height:1; margin-bottom:0;  white-space:nowrap;height:1px"/>          </td>
        </tr>
      </table>
    </form></td>
</tr>
<tr style ="padding: 0, 0, 0, 0" width ="100%">
<td colspan="5" style ="padding: 0, 0, 0, 0">

        <table id = "Main" width ="100%" style="padding: 0px 0px 0px 0px">
          <tr width ="100%" style ="padding:0px 0px 0px 0px;" >
            <td id = "LeftCell" width ="200" style ="font-size:medium; padding:0px 0px 0px 0px; " align ="left"  valign="top" >
                <div id = "LeftPanel" 
                    style="overflow:auto;visibility:visible; padding-top: 3px; padding-right: 0px; padding-left: 3px;"></div> 
            </td>
            <td style="width: 1px; padding: 0px 0px 0px 0px; ">
            <div id ="CollapsableBar" style ="padding:0px 0px 0px 0px" > 
                <img id ="HideShowToggle" style="padding:0px 0px 0px 0px" src="images/hide-arrowOrange.png" 
                onclick ="ShowHideLeftPanel('LeftPanel')" onmouseover="changeCur(this)" /></div></td>
            <td style ="padding: 0, 0, 0, 0; "  valign="top">
                <div id="map" onmousewheel = "WheelZoom()" style="width: window.innerWidth; margin-top: 1px">
                </div>
                <div id="pano"  style="width: window.innerWidth; ">
                </div>
            </td>
            
            <td style="width: 1px; padding: 0px 0px 0px 0px; "><div id ="Div1" style ="padding:0px 0px 0px 0px" > 
                <img id ="HideShowToggle2" style="padding:0px 0px 0px 0px; " src="images/show-arrowOrange.png" 
                onclick ="ShowHideRightPanel('LeftPanel')" onmouseover="changeCur(this)" /></div></td>
            
            <td id = "RightCell" width ="185" style ="font-size:12px; padding:0px 0px 0px 0px; " align ="left"  valign="top" >
                <div id = "RightPanel" style="overflow:auto; visibility:visible; padding:0px 0px 0px 0px">
                <form id = 'frmToggle' onsubmit='toggleLayers(); return false' name='frmToggle' style='font-family:; 'Trebuchet MS'; font-size: 12px;'> 
                <div style='text-align: center; font-size: 15px; font-weight: bold; color: #074379; vertical-align: bottom; padding-top: 4px;'>Add data to the map!</div>
                <div style="font-size: x-small; text-align: right"><a href="howToAddData.html" onclick='showPopup4(this.href);return(false);' style="color: #FF0000">How?</a></div>
                <hr /> 
                
                 <div style='font-weight: normal'> <input id='chkDesignated' align='top'  name='chkDesignated' type='checkbox'/>Designated Bike Routes
                 <br />
                 <input id='chkAlternate' align='top'  name='chkAlternate' type='checkbox'/>'Alternate' Bike Routes
                 <br />
                 <input id='chkSignals' align='top'  name='chkSignals' type='checkbox'/>Cyclist Controlled Crossings
                 <br />
                 <input id='chkST' align='top'  name='chkST' type='checkbox'/>SkyTrain
                 <br />
                 <input id='chkSTstn' align='top'  name='chkSTstn' type='checkbox'/>SkyTrain Stations
                 <br />
                 <input id='chkOther' align='top'  name='chkOther' type='checkbox'/>Other Bike-Friendly 
                     Routes
                 <br />
                 <input id='chkNoBikes' align='top'  name='chkNoBikes' type='checkbox'/>Rds. Prohibited for Cycling
                 <br />
                 <input id='chkTrucks' align='top'  name='chkTrucks' type='checkbox'/>Truck Routes (Van.)
                 <br />
                 <input id='chkFountains' align='top'  name='chkFountains' type='checkbox'/>Drinking Fountains (Van.)
                 <br />
                 <input id='chkSchools' align='top'  name='chkSchools' type='checkbox'/>Schools (Van.)
                 <br />
                 <input id='chkCmtyCntrs' align='top'  name='chkCmtyCntrs' type='checkbox'/>Community Centers (Van.)
                 <br />
                 <input id='radNO2' type='radio' name='rasters' />Air Pollution Image
                 <br />
                 <input id='radGreen' type='radio' name='rasters' />Vegetation Image
                 
                 <!--<br />
                 <input id='radSlope' type='radio' name='rasters' />Slope Image (slow to load)--></div>
                 <hr />
                 <div style='text-align: center; font-weight: bold;  '>
                 <a href='/Legend.htm' onclick='showPopup4(this.href);return(false);' font-size: 14px; >Legend</a></div>
                 <hr />
                 <div style='text-align: center'><a href='javascript:fcnClearAll()' style='font-weight: bold; font-size: 10px;' >Clear Selection</a>
                 <br />
                 <br />
                 <input id='btnToggle' type='submit' value='Update Layers'/></div></form>
                </div>   
            </td>
             
          </tr>
            
        </table>
  
</tr>



<Table style ="padding: 0, 0, 0, 0" width ="100%">
  <tr>
    <td width="20%"><div align="center" class="style13"><a href='WhatsNew.htm'target='_blank' style="color:#dd0000" onClick='showPopup3(this.href);return(false);'>What's New?</a></div></td>
    <td width="20%"><div align="center" class="style13"><a href='http://cvtest.soeh.ubc.ca'target='_blank' onClick='showPopup4(this.href);return(false);'>Mobile Site</a></div></td>
    <td width="20%"><div align="center" class="style13"><a href="Documentation_Disclaimer.html" target="_blank">Disclaimer & Documentation </a></div></td>
    
    
	
    <td width="20%"><div align="center" class="style13"><a href="http://www.cher.ubc.ca/cyclingincities/neighbourhood.html" target="_blank">About Us</a> </div>
</td>
    <td width="20%"><div align="center" class="style13"><a href="mailto:cycling.planner.updates@gmail.com?subject=Feedback">Feedback</a></div>      
    <div align="center" class="style13"></div></td>
  </tr>
</table>
<Table width ="100%" height="auto" style ="padding: 0, 0, 0, 0">
  <tr>
    <td width="200" height="auto"></td>
    <td width="(100%-200)"><div align="center" valign="top" class="style14 style17"><span class="style20"> © The University of British Columbia, 2007. All rights reserved</span></div></td>
  </tr>
</table>
<!-- </MN>-->
<form name="form1" id="form1" runat="server">
  <asp:ScriptManager ID="ScriptManager1" runat="server">
    <Services>
      <asp:ServiceReference Path="RouteService.asmx" />
    </Services>
  </asp:ScriptManager>
</form>

<script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
var pageTracker = _gat._getTracker("UA-5015637-2");
pageTracker._trackPageview();

        </script>

</body>

</html>
