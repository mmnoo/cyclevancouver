<%@ Page Language="C#" AutoEventWireup="true" CodeFile="logout.aspx.cs" Inherits="logout" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
   <table width="100%">
    <tr>
        <td align="center">
            You have been logged out.
            <br /><asp:hyperlink id="hlLogin" runat="server" 
            navigateurl="default.aspx">Log back in.</asp:hyperlink>
        </td>
    </tr>
</table>

    </form>
</body>
</html>
