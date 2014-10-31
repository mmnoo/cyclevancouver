<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Default3" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Cycling Route Planner</title> 
    <script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAAzgnQkUSe3J6IElQAHFBQOBTLUkhTJp9piEDXfBAGBDdkN5dApxTbsm7oPYQbMI8NurlFHfXRyb8YbA" type="text/javascript"></script>
<script type="text/javascript">

    function PageLoad(){
        
        if (GBrowserIsCompatible()) { 

            var map = new GMap2(document.getElementById("map"));
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
        }
    
        // display a warning if the browser was not compatible
        else {
            document.getElementById("feedback").innerHTML= "Browser not compatible.";
            //alert("Sorry, the Google Maps API is not compatible with this browser");
        }
    
    
 
        window.moveTo(0,0);
        window.resizeTo(screen.availWidth, screen.availHeight);

        SetMapDimension();
        RouteService.Service_Initialization();
        document.getElementById("LeftPanel").style.fontSize= "small";
        document.getElementById("LeftPanel").innerHTML= 
			"<b>Data Sources:</b><hr>Translink: <a href='CyclingRouteData.html'target='_blank' class='style3' onClick='showPopup2(this.href);return(false);'>cycling route data</a><br><br>Google Maps:underlying road network and images for display<br><br>DMTI Spatial:<a href='DEM.html'target='_blank' class='style3' onClick='showPopup2(this.href);return(false);'>digital elevation data</a><br><br>United States Geological Survey:<a href='LandCovVeg.html'target='_blank' class='style3' onClick='showPopup2(this.href);return(false);'>Land cover data for vegetation classification </a><br><br>Border Air Quality Study team:<a href='PolVeg.html'target='_blank' class='style3' onClick='showPopup2(this.href);return(false);'>traffic pollution</a> and vegetation classification results<br><br>Developed by the <a href='http://www.cher.ubc.ca/cyclingincities/default.htm' target='_blank' class='style3'>Cycling in Cities</a> project team at the University of British Columbia, in cooperation with <a href='http://www.translink.bc.ca/' target='_blank' class='style3'>Translink</a>. Funded in part by a research grant from the Heart and Stroke foundation of Canada and the Canadian Institute for Health Research. </HR><br><br><B><a href='Documentation_Disclaimer.html'target='_blank' class='style3'>Please read our disclaimer and documentation</b></a>";
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
        document.getElementById("LeftPanel").style.height= bodyHeight2 + "px";

    }

	//MN edited this to conform with Route Preference combo box name and order changes, not sure yet if this impacts server code....
    function setOption(form, index) {
      for (var i = 0; i < form.RoutePreference.length; i++) {
        form.RoutePreference.options[i].text = "";
      }

      if (index == 0) {
        form.RoutePreference.options[0].text = "Least Elevation Gain";
        form.RoutePreference.options[2].text = "Least Traffic Pollution";
        form.RoutePreference.options[1].text = "Restricted Maximum Slope";
        form.RoutePreference.options[3].text = "Most Vegetated Routes";
      }
      else if (index == 1) {
        form.RoutePreference.options[0].text = "Least Elevation Gain";
        form.RoutePreference.options[2].text = "Least Traffic Pollution";
        form.RoutePreference.options[1].text = "Restricted Maximum Slope";
        form.RoutePreference.options[3].text = "Greenest Routes";
      }
      form.RoutePreference.selectedIndex = 0;
      setVisibility(0);
    }


    function setVisibility(index)
    {
        if( index == 0)
        {
            document.all["Slope"].style.visibility= "visible";
            document.all["slopeTxt"].style.visibility= "visible";
        }
        else
        {
            document.all["Slope"].style.visibility= "hidden";
            document.all["slopeTxt"].style.visibility= "hidden";
        }
    
    }

    var state = "visible";
    function ShowHideLeftPanel(layer_ref) {
        if (state == "visible") {
            state = "hidden";
            document.getElementById("LeftCell").width = "1px";
            document.getElementById(layer_ref).style.width="1px";
            document.getElementById("HideShowToggle").src="images/show-arrow.png";                        
        }
        else {
            state = "visible";
            document.getElementById("LeftCell").width = "200px";
            document.getElementById(layer_ref).style.width="200px";            
            document.getElementById("HideShowToggle").src="images/hide-arrow.png";                        
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
    
    //----- Stop page scrolling if wheel over map ---- 
    function WheelZoom(e) 
    { 
        if (!e) e = window.event; 
        if (e.preventDefault) e.preventDefault(); 
        e.returnValue = false; 
        map.addDomListener(map, "DOMMouseScroll", WheelZoom); 
        map.onmousewheel = WheelZoom; 
    } 

    function WheelZoom(e){
    if (map.addEventListener) 
            map.addEventListener("DOMMouseScroll", function(e) 
        { e.preventDefault(); }, false); 
    else if (map.attachEvent) 
            map.attachEvent("onmousewheel", function() { event.returnValue = false; });         
    }
    
 </script>

<script type="text/javascript" src ="planner.js"></script>


<style type="text/css">
<!--
.style3 {
	font-size: small;
	font-family: "trebuchet MS";
		}
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
.style22 {color: #808080}
.style23 {font-size: 12px}

-->
</style>
</head>
<body onload = "PageLoad()" onunload="GUnload()" topmargin = "5px" scroll ="no">

 <body
 bgcolor="#FFFFFF"
 text="style4">
 <Table style ="padding: 0, 0, 0, 0" width ="100%">
<tr style ="padding: 0, 0, 0, 0" width ="100%">
<td width ="100%" colspan="5" class="style4" style ="padding: 0, 0, 0, 0">
    <form id="infoForm" name = "infoForm" onsubmit="SearchRoute(); return false" style="margin-bottom:0;" >
      <table width="100%" align ="left" bgcolor="#F6F6F6" style ="padding: 0, 0, 0, 0" >
        <tr style ="padding: 0, 0, 0, 0" align ="left" width ="200px">
          <th rowspan = 4 align ="center" width ="190" > <img style="padding:0px 0px 0px 0px" src = "images/cycle4.png" width ="190px" height="70px"/> </th>
          <td style="font-size:9px; height:8px;">From Address <a href='AddressInfo.html'target="_blank" class="style3 style19" onclick='showPopup(this.href);return(false);'><span class="style23">Address Formatting Info</span></a> <span class="style22"> </span></td>
          <td></td>
          <td style="font-size:9px">To Address</td>
          <td style="font-size:9px">Speed (km/hr)</td>
        </tr>
        <tr height="10px">
          <td width ="273"><input name="addrStart" type="text" id="addrStart" style="width: 273px" value="105 Commercial, Vancouver"/></td>
          <td width="32" align ="center"><img src="images/ddirflip.gif" width=13px onclick="FlipText()" onmouseover="changeCur(this)" /></td>
          <td width ="273"><input name="addrEnd" type="text" id="addrEnd" style="width: 273px" value="Van Dusen Botanical Gardens, Vancouver" /></td>
          <td width ="103"><input id="Speed" name ="Speed" type="text" value="15" style="width: 80px"/></td>
          <td colspan ="2" style="width: 648px"><input name="submit" type="submit" value="Get Directions"/>
              <span class="style19">
              <script type="text/javascript">
				function showPopup(url)
				 {
					newwindow=window.open(url,'Address Formatting Info Window','height=550,width=400,top=200,left=600,resizable');
					if (window.focus) {newwindow.focus()}
				 }
				 function showPopup2(url)
				 {
					newwindow=window.open(url,'Data Source','height=275,width=550,top=200,left=600,resizable');
					if (window.focus) {newwindow.focus()}
				 }
			  </script>
              </span>
              <!--<a href="AddressInfo.html" target="_blank" class="style3">Address Formatting Info Window</a>/-->          </td>
        </tr>
        <tr style ="padding: 0, 0, 0, 0" height="8px">
          <td style="font-size:9px;">Route Type</td>
          <td style="height: 6px"></td>
          <td style="font-size:9px;">Preference</td>
          <td style="font-size:9px;" visible ="false"><label id="slopeTxt">Max. Slope (%) </label></td>
        </tr>
        <tr height="10px">
          <td><select id="RouteCategory" name = "RouteCategory" onchange="setOption(this.form, this.selectedIndex)" style="font-size:14px;">
              <option>Designated + Alternate Cycling Routes</option>
              <option selected="selected">Major Roads Included</option>
            </select>          </td>
          <td></td>
          <td><select id="RoutePreference" name = "RoutePreference" onchange="setVisibility(this.selectedIndex)" style="font-size:14px;">
              <option selected="selected">Least Elevation Gain</option>
              <option>Least Traffic Pollution</option>
              <option>Restricted Maximum Slope</option>
              <option>Most Vegetated Routes</option>
                      </select>          </td>
          <td><input id="Slope" name = "Slope" type="text" value="10" style="width: 80px;"/></td>
          <td width="254" height="8px"><b><label id="rteSearch" style="font-size:13px; width:1px;" ></label></b></td>
          <td width="367" height="8px"><label id="feedback" style="color:Red; font-size:12px; width: 200px"></label></td>
        </tr>
        <tr height="2px" style="padding:0 0 0 0">
          <td colspan ="7" style="padding:0 0 0 0; height: 1px;"><hr width ="100%" style=" line-height:1; line-height:1; margin-bottom:0;  white-space:nowrap;height:1px"/>          </td>
        </tr>
      </table>
    </form></td>
</tr>
<tr style ="padding: 0, 0, 0, 0" width ="100%">
<td colspan="5" style ="padding: 0, 0, 0, 0">

        <table id = "Main" width ="100%" style="padding: 0px 10px 0px 0px">
          <tr width ="100%" style ="padding:0px 0px 0px 0px">
            <td id = "LeftCell" width ="200" style ="font-size:medium; padding:0px 0px 0px 0px" align ="left"  valign="top" ><div id = "LeftPanel" style="overflow:auto;height:auto;visibility:visible; padding:0px 0px 0px 0px"></div> </td>
            <td style="width: 2px; padding: 0px 0px 0px 0px"><div id ="CollapsableBar" style ="padding:0px 0px 0px 0px" > <img id ="HideShowToggle" style="padding:0px 0px 0px 0px" src="images/hide-arrow.png" onclick ="ShowHideLeftPanel('LeftPanel')" onmouseover="changeCur(this)" /></div></td>
            <td style ="padding: 0, 0, 0, 0" ><div id="map" onmousewheel = "WheelZoom()"  style="width: window.innerWidth; padding: 0 0 0 0; "></div></td>
          </tr>
        </table></td>
</tr>
</table>

<Table width ="100%" height="42" style ="padding: 0, 0, 0, 0">
  <tr>
    <td width="200" height="34"><div align="right" style="overflow:auto;height:auto;visibility:visible; padding:0px 0px 0px 0px"></div></td>
    <td width="(100%-200)"><div align="right" class="style14 style17"><span class="style20"> © The University of British Columbia, 2007. All rights reserved</span></div></td>
  </tr>
</table>
<Table style ="padding: 0, 0, 0, 0" width ="100%">
  <tr>
    <td width="474"><div align="center" class="style13"><a href="Documentation_Disclaimer.html" target="_blank">Disclaimer and Documentation </a></div></td>
    <td width="474"><div align="center" class="style13"><a href="http://www.cher.ubc.ca/cyclingincities/neighbourhood.html" target="_blank">About US</a> </div></td>
    <td width="474"><div align="center" class="style13"><a href="http://www.translink.bc.ca/transportation_services/bikes/cycle_routePlanner.asp" target="_blank">Feedback</a></div>      
    <div align="center" class="style13"></div></td>
  </tr>
</table>
<form name="form1" id="form1" runat="server">
  <asp:ScriptManager ID="ScriptManager1" runat="server">
    <Services>
      <asp:ServiceReference Path="RouteService.asmx" />
    </Services>
  </asp:ScriptManager>
</form>
</body>

</html>
