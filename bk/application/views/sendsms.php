<?php
function gw_send_sms($user,$pass,$sms_from,$sms_to,$sms_msg)  
            {           
                        $query_string = "api.aspx?apiusername=".$user."&apipassword=".$pass;
                        $query_string .= "&senderid=".rawurlencode($sms_from)."&mobileno=".rawurlencode($sms_to);
                        $query_string .= "&message=".rawurlencode(stripslashes($sms_msg)) . "&languagetype=1";        
                        $url = "http://gateway.onewaysms.com.ph:10001/".$query_string;       
                        $fd = @implode ('', file ($url));      
                        if ($fd)  
                        {                       
				    if ($fd > 0) {
					Print("MT ID : " . $fd);
					$ok = "success";
				    }        
				    else {
					print("Please refer to API on Error : " . $fd);
					$ok = "fail";
				    }
                        }           
                        else      
                        {                       
                                    // no contact with gateway                      
                                    $ok = "fail";       
                        }           
                        return $ok;  
            }  
     Print("Sending to one way sms " . gw_send_sms("apiusername", "apipassword", "senderid", "61412345678", "test message"));
?>