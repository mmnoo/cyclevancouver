using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Text.RegularExpressions;
using System.Collections;


public partial class _Default : System.Web.UI.Page
{
    string strCurrentUser = HttpContext.Current.User.Identity.Name;
    protected void Page_Load(object sender, EventArgs e)
    {

        lblLogIn.Text = " <b>Logged in as: " + strCurrentUser+ "</b>";
       
    }
    protected void btnAddSignal_Click(object sender, EventArgs e)
    {   
        // Specify a file to read from and to create.
        string pathSource = Server.MapPath("~/EditSignals/bike_signal.xml");
        string pathNew = Server.MapPath("~/EditSignals/bike_signal.xml");
        double lat = 0;
        double lng = 0;
        //get the signal coordinates, make sure the text boxes arent empty or containing junk values
        if (txtLat.Text != String.Empty && txtLng.Text != String.Empty)
        {
            //lat = Convert.ToDouble(txtLat.Text);
            //lng = Convert.ToDouble(txtLng.Text);
            bool isNumLat = double.TryParse(txtLat.Text.Trim(), out lat);
           // if (!isNumLat) { lblResponse.Text = "not number"; }
            bool isNumLng = double.TryParse(txtLng.Text.Trim(), out lng);
            //if (!isNumLng) { lblResponse.Text = " lng not number"; }
            
        }
        if (txtLat.Text == String.Empty)
        {
            lblResponse.Text = "Please click the map or enter a latitude coordinate value";
        }
        else if(txtLng.Text == String.Empty)
        {
            lblResponse.Text = "Please click the map or enter a longitude coordinate value";
        }
        else if (drpDirection.SelectedValue == "--")
        {
            lblResponse.Text = "Please select a crossing direction";
        }
        else if (lng <= -123.3 || lng > -122.27)
        {
            lblResponse.Text = "Please select a numeric latitude value east of -123.3° and west of -122.27°";
        }
        else if (lat >= 49.4 || lat < 48.8)
        {
            lblResponse.Text = "Please select a numeric latitude value south of 49.4° and north of 48.8°";
        }

        else
        {
            try
            {

                using (FileStream fsSource = new FileStream(pathSource,
                    FileMode.Open, FileAccess.Read))
                {

                    // Read the crossing signal file into a byte array.
                    byte[] bytes = new byte[fsSource.Length];
                    int numBytesToRead = (int)fsSource.Length;
                    int numBytesRead = 0;
                    while (numBytesToRead > 0)
                    {
                        // Read may return anything from 0 to numBytesToRead.
                        int n = fsSource.Read(bytes, numBytesRead, numBytesToRead);

                        // Break when the end of the file is reached.
                        if (n == 0)
                            break;

                        numBytesRead += n;
                        numBytesToRead -= n;
                    }
                    numBytesToRead = bytes.Length - 12;
                    fsSource.Close();

                    // Write the byte array to the other FileStream.
                    using (FileStream fsNew = new FileStream(pathNew,
                        FileMode.Create, FileAccess.Write))
                    {
                        fsNew.Write(bytes, 0, numBytesToRead);

                    }
                    //using time as unique identifier for the xml
                    string now = DateTime.Now.Year.ToString() + DateTime.Now.Month.ToString() + DateTime.Now.Day.ToString() + DateTime.Now.Hour.ToString()
                        + DateTime.Now.Minute.ToString() + DateTime.Now.Second.ToString() + DateTime.Now.Millisecond.ToString();
                        
                    StreamWriter sw;
                    sw = File.AppendText(pathNew);
                    sw.WriteLine("<marker id='" + now + "' editor='" + strCurrentUser + "' lat='" + txtLat.Text + "' lng='" + txtLng.Text + "' infoWin='" + drpDirection.SelectedItem + "'/>");
                    sw.WriteLine("</markers>");
                    sw.Close();
                    lblResponse.Text = "Your cyclist controled crossing button has been added to the database!";
                    txtLat.Text = "";
                    txtLng.Text = "";
                    drpDirection.ClearSelection();
                    Response.Redirect("~/EditSignals/sigAddedConf.aspx");
                }
            }
            catch (FileNotFoundException ioEx)
            {
                Console.WriteLine(ioEx.Message);
                lblResponse.Text = ioEx.Message;
            }
        }
    }
    protected void btnDeleteSignal_Click(object sender, EventArgs e)
    {
        int matchID = 0;
        lblDelete.Text = "";
        //check if text box is emty
        if (txtDelete.Text == string.Empty)
        {
            lblDelete.Text = "Please ender an ID number";
        }
        else
        {
            
            string xmlID = "id='" + txtDelete.Text.Trim() + "'";
            string filePath = Server.MapPath("~/EditSignals/bike_signal.xml");
            StreamReader reader = new StreamReader(filePath);
            //declare an array to temporarily hold the lines from the xml file
            ArrayList tmpArray = new ArrayList();
            //read through the xml testing if there is a match on ID
            string line;
            while ((line = reader.ReadLine()) != null)
            {
                if (Regex.IsMatch(line, xmlID))
                {
                    //dont write anything, skip adding the line to be deleted to the array
                    matchID = 1;                  
                }
                else
                {
                    //write lines to keep to the array
                    tmpArray.Add(line);
                }
            }
            reader.Close();
            if (matchID ==1)
            {   //overwrite the contents of the original crossing button file with 
                //the contents of the array (which will exclude the crossing to be deleted)
                StreamWriter writer = new StreamWriter(filePath);
                int count = 0;
                foreach (string i in tmpArray)
                {
                    writer.WriteLine(tmpArray[count]);
                    count = count + 1;
                }
                writer.Close();
                //redirect the user to a confirm page
                //this also prevents the server methods being called when a user refreshes the page after hitting a submit butto
                Response.Redirect("~/EditSignals/sigDeletedConf.aspx");
            }
            else
            {
                lblDelete.Text = "The server could not find a crossing button with that ID";
            }
        }
    }
}
