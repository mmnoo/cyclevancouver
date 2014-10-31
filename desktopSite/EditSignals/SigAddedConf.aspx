<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SigAddedConf.aspx.cs" Inherits="Default2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
<br />
<br />
<div style="font-weight: bold; text-align: center; font-size: large;">Your cyclist-controlled crossing button has been added the database</div>
<br />

<div style="text-align: center; font-weight: bold; color: #960024;">If you cannot 
    view the crossing button in the map after you click OK, try clearing your 
    browser&#39;s cache and refreshing.<br />
    To see instructions for doing this <a href="http://www.wikihow.com/Clear-Your-Browser&#39;s-Cache" >click here</a></div>
<br />
    <form id="form1" runat="server">
    <div style="text-align: center">
        <asp:Button ID="btnOK" runat="server" Text="OK" OnClick="btnOK_Click" />
    </div>
    </form>
</body>
</html>
