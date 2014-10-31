<%@ Page language="C#" Debug="true"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.OleDb" %>
<%@ Import Namespace="System.Web.Security" %>
<%@ Register TagPrefix="MySite" TagName="Login" Src="login.ascx" %>

<script language="C#" runat="server">
private void Page_Load(Object sender, EventArgs E) {
 
     Page.Validate();
if ((Page.IsPostBack) && (Page.IsValid)) {
   string strDSN =
   "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=c:\\inetpub\\wwwroot\\Route\\EditSignals\\member.mdb";
   string strSQL = "SELECT userName, userPassword FROM Membership WHERE userName='" + MyLogin.UserId + "'";

   OleDbConnection myConn = new OleDbConnection(strDSN);
   OleDbCommand myCmd = new OleDbCommand(strSQL, myConn);
   OleDbDataReader dr = null;
   try {
    myConn.Open();
    dr = myCmd.ExecuteReader();

    if(dr.Read()) {
        if(dr.GetString(1).Trim() == MyLogin.Password.Trim()) {
               FormsAuthentication.RedirectFromLoginPage(MyLogin.UserId, false);
        }
        else
                   Message.Text = "Sorry! Your login or password is incorrect. <br>Please log in again.";
    }
    else
    {
        Message.Text = "Sorry! Your login or password is incorrect. <br>Please log in again.";
    }
   }
   catch(Exception myException) {
    Response.Write("Oops. The error: " + myException.Message);
   }
   finally {
    myConn.Close();
}
}
}
</script>
<html>
<head><title></title></head>
<body>
<h3>Login to edit cyclist-controlled crossings database</h3>
<form runat="server" ID="Form1">
<asp:Label id="Message" runat="server" />
<MySite:Login id="MyLogin" BackColor="#FFFFCC" runat="server"/>
</form>
</body>
</html>
