<%@ Page Language="C#" Debug="true" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="asp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="-1" /> <!-- no cache for IE 5-->
    <title>Add Cyclist-Controlled Crossing Buttons</title>
<script src="http://maps.google.com/maps?file=api&amp;v=2.x&amp;key=ABQIAAAAYD5sxaBVp3byjEakhpZcxRRPbZ4hl9O3TrKJpvAAEYuJj_Ia7xScTAY86n0ETCo97gtrAOMV2pbuZA&sensor=false" type="text/javascript"></script>
<script type="text/javascript">
   document.write('<script type="text/javascript" src="http://gmaps-utility-library-dev.googlecode.com/svn/tags/markermanager/1.1/src/markermanager' + (document.location.search.indexOf('packed') > -1 ? '_packed' : '') + '.js"><' + '/script>');
</script>
<script type="text/javascript">

    var mgr;
    var geocoder;
    var signalMark;
    var place;
    var point;
    var click = 0;
    function PageLoad() {
        if (GBrowserIsCompatible()) {        
            var map = new GMap2(document.getElementById("map"));
            map.setCenter(new GLatLng(49.323297, -123.006936), 12);
            map.setUIToDefault();
            displaySignals();
            GEvent.addListener(map, "click", getAddress);
           //http://code.google.com/apis/maps/documentation/events.html
            //http://www.aspnettutorials.com/tutorials/file/rw-file-aspnet2-csharp.aspx
            //http://sappidireddy.wordpress.com/2008/03/31/how-to-call-server-side-function-from-client-side-code-using-pagemethods-in-aspnet-ajax/
            //enable marker manager for signals
            mgr = new MarkerManager(map);
        }//end isBrowserCompatible

        
    function getAddress(overlay, latlng) {
        geocoder = new GClientGeocoder();
        if (latlng != null) {
            address = latlng;
            geocoder.getLocations(latlng, showAddress);
        }
    }
    function showAddress(response) {
        //map.clearOverlays();
        if (!response || response.Status.code != 200) {
            alert("Status Code:" + response.Status.code);
        }
        else {
            if (click == 1) {
                map.removeOverlay(signalMark);
            }
            place = response.Placemark[0];
            point = new GLatLng(place.Point.coordinates[1], place.Point.coordinates[0]);
            signalMark = new GMarker(point);
            map.addOverlay(signalMark);
            click = 1;
            document.sigForm.txtLat.value = (place.Point.coordinates[1]);
            document.sigForm.txtLng.value = (place.Point.coordinates[0]);


        }
    }

    function displaySignals() {
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
                var infoWin = "<b>Crossing Direction: </b>" + markers[i].getAttribute("infoWin") + "<br> <b>ID: </b>" + markers[i].getAttribute("id") + "<br><b> Editor: </b>" + markers[i].getAttribute("editor");
                // create the marker
                var marker = createMarker(point, infoWin, icon);
                batch.push(marker);
            }

            mgr.addMarkers(batch, 0, 17);
            mgr.refresh();

        });
    }
    SetMapDimension();
    map.checkResize();
} //end pageload
function SetMapDimension() {

    var bodyWidth, bodyHeight;
    var bodyWidth2, bodyHeight2;
    if (typeof (window.innerWidth) == 'number') {
        //Non-IE
        //bodyWidth = window.innerWidth;
        bodyHeight = window.innerHeight;
    }
    else if (document.documentElement && (document.documentElement.clientWidth || document.documentElement.clientHeight)) {
        //IE 6+ in 'standards compliant mode'
        //bodyWidth = document.documentElement.clientWidth;
        bodyHeight = document.documentElement.clientHeight;
    }
    else if (document.body && (document.body.clientWidth || document.body.clientHeight)) {
        //bodyWidth = document.body.clientWidth;
        bodyHeight = document.body.clientHeight;
    }
    bodyHeight2 = bodyHeight -100;
    document.getElementById("map").style.height = bodyHeight2 + "px";
    

}

</script>
<link rel="stylesheet" 
type="text/css" href="EditSignals.css" />
</head>
<body onload = "PageLoad()" onunload="GUnload()">
    <table id="main">
    <tr><td id="PageTitle" colspan="2">Add/Delete Cyclist-Controlled Crossing Buttons
    </td>
    </tr>
    <tr>
    <td id = "LeftCell">
        <div id = "LeftPanel">
        <form id="sigForm" name = "sigForm" runat="server" method="post">
        <asp:ScriptManager ID="MainScriptManager" runat="server" />
        <table id ="Add">
        <tr><td colspan="2">
        <p class="label1">
        Add Crossing Button
        </p>
        </td>
        </tr>
        <tr>
        <td colspan="2">
        <p class="text">
        To add a crossing button, enter its coordiantes below or click the map at the desired location.
        Indicate the direction of crossing and then click Add Crossing Button.</p>
        </td></tr>
        <tr>
        <td><p class="label2">Latitude:</p></td>
         <td><asp:TextBox ID="txtLat" runat="server" Width="100px"></asp:TextBox></td>
        </tr>
        <tr>
        <td ><p class="label2">Longitude:</p> </td>
        <td><asp:TextBox ID="txtLng" runat="server" Width="100px"></asp:TextBox></td>
        </tr>
        <tr>
        <td><p class="label2">Direction:</p></td>
        <td>
            <asp:DropDownList ID="drpDirection" runat="server">
                <asp:ListItem value="--" selected="True">--</asp:ListItem>
                <asp:ListItem value="East/West" selected="False">Eastbound/Westbound</asp:ListItem>
                <asp:ListItem value="North/South" selected="False">Northbound/Southbound</asp:ListItem>   
            </asp:DropDownList>
        </td>
        </tr>
        <tr>
        <td colspan="2">
        <!--<br /><input id="addSignal" runat="server" type="submit" value="Add Signal" onclick="btnAddSignal_Click" />-->
        <asp:Button runat="server" ID="btnAddSignal" OnClick="btnAddSignal_Click" Text="Add Crossing Button" />  
        </td>
        </tr>
        <tr>
        <td colspan="2">
        <asp:Label runat="server" ID="lblResponse" ForeColor="#A34E67"  />
        </td> 
        </tr>
        </table>
        <table id="Delete">
        <tr><td></td></tr>
        <tr><td colspan="2">
        <p class="label1">
            Delete Crossing Button
            </p>
        </td></tr>
        <tr><td colspan="2">
        <p class="text">
        To delete a crossing button, enter its ID number in the box below and click Delete Crossing Button.
        To obtain a crossing Button's ID, click on it in the map and copy the ID number from the information window.
        </p>
        </td></tr>
        <tr>
        <td>
        <p class="label2">Signal ID:</p>
        </td>
        <td>
        <asp:TextBox ID="txtDelete" runat="server" Width="160px"></asp:TextBox>
        </td>
        </tr>
        <tr>
        <td colspan ="2"><asp:Button runat="server" ID="btnDelete" OnClick="btnDeleteSignal_Click" Text="Delete Crossing Button" /> </td>
        </tr>
        <tr><td colspan ="2"><asp:Label runat="server" ID="lblDelete" ForeColor="#A34E67"  /> </td></tr>
        </table>

        
        <a href="mailto:cycling.planner.updates@gmail.com?subject=Feedback">Comments</a></form>
       
        </div>
    </td>
    <td>
        <div id="map">
        </div>
    </td>
    </tr>
    <tr>
    <td colspan="2">
    <div id="BottomPanel">
    <div ><asp:Label runat="server" ID="lblLogIn" />
    </div>   
    
    <asp:HyperLink id="hlLogout" runat="server" NavigateUrl="logout.aspx">Log Out</asp:HyperLink>
    </div>
    </td>
    </tr>
    </table>

        

    



</body>
</html>
