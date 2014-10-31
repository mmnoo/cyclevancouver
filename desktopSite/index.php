<?php 

class Client
{
    /**
     * Available Mobile Clients
     *
     * @var array
     */
    private $_mobileClients = array(
        "midp",
        "240x320",
        "blackberry",
        "netfront",
        "nokia",
        "panasonic",
        "portalmmm",
        "sharp",
        "sie-",
        "sonyericsson",
        "symbian",
        "windows ce",
        "benq",
        "mda",
        "mot-",
        "opera mini",
        "philips",
        "pocket pc",
        "sagem",
        "samsung",
        "sda",
        "sgh-",
        "vodafone",
        "xda",
        "iphone",
        "android"
    );

    /**
     * Check if client is a mobile client
     *
     * @param string $userAgent
     * @return boolean
     */
    public function isMobileClient($userAgent)
    {
        $userAgent = strtolower($userAgent);
        foreach($this->_mobileClients as $mobileClient) {
            if (strstr($userAgent, $mobileClient)) {
                //return true;
				//
				//echo "mobile";
				$mobile = 1;
            }
			
			
        }
		//else echo "not mobile";
		//
        //return false;
		if ($mobile == 1) {header( 'Location: http://cvtest.soeh.ubc.ca/' );}
		else { header( 'Location: http://www.cyclevancouver.ubc.ca/cv.aspx' );}
    }

}

$client = new Client();
$client->isMobileClient($_SERVER['HTTP_USER_AGENT']);


 ?>