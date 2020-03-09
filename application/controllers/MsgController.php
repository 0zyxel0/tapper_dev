<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class MsgController extends CI_Controller
{


    function __construct() {
        parent::__construct();
        $this->load->model('DataModel');
    }

function test(){
    print_r($_POST);


    $message= $this->input->post('message');
    $name = $this->input->post('StudentNames');
    $finalmsg = $name . " " . $message;
    echo $finalmsg;
}

    function send_NotificationToGuardian($NumberTo, $msg){

       $url = 'http://192.168.1.4:8080';
       $ch = curl_init($url);
        $jsonData = array(
            'number' => $NumberTo,
            'text' => $msg
        );
        $jsonDataEncoded = json_encode($jsonData);
        curl_setopt($ch, CURLOPT_POST, 1);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $jsonDataEncoded);
        curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/json'));
        curl_exec($ch);
    }




function send_SingleSms_Phone(){

    $NumberTo = $this->input->post('NumberTo');
    $message= $this->input->post('message');
    $name = $this->input->post('StudentNames');
    $con_msg = $name ." ". $message;

    //API Url
    $url = 'http://192.168.1.4:8080';

//Initiate cURL.
    $ch = curl_init($url);

//The JSON data.
    $jsonData = array(
        'number' => $NumberTo,
        'text' => $message
    );

//Encode the array into JSON.
    $jsonDataEncoded = json_encode($jsonData);

//Tell cURL that we want to send a POST request.
    curl_setopt($ch, CURLOPT_POST, 1);

//Attach our encoded JSON string to the POST fields.
    curl_setopt($ch, CURLOPT_POSTFIELDS, $jsonDataEncoded);

//Set the content type to application/json
    curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/json'));

//Execute the request
   curl_exec($ch);
   
}
function send_SingleSms_Semaphore(){


        $NumberTo = $this->input->post('NumberTo');
        $message= $this->input->post('message');
        $name = $this->input->post('StudentNames');
        $con_msg = $name ." ". $message;
        log_message("INFO", implode("; ", [trim($NumberTo), $con_msg]));
        $ch = curl_init();
        $parameters = array(
            'apikey' => '24da6cd44efc8df71385f0c1308b6548', //Your API KEY
            'number' => $NumberTo,
            'message' => $message,
            'sendername' => ''
        );
        curl_setopt( $ch, CURLOPT_URL,'https://semaphore.co/api/v4/messages' );
        curl_setopt( $ch, CURLOPT_POST, 1 );

//Send the parameters set above with the request
        curl_setopt( $ch, CURLOPT_POSTFIELDS, http_build_query( $parameters ) );

// Receive response from server
        curl_setopt( $ch, CURLOPT_RETURNTRANSFER, true );
        $output = curl_exec( $ch );
        curl_close ($ch);

//Show the server response
        echo
        $output;
}

function send_bulkSms(){
    $NumberTo = $this->input->post('NumberTo');
    $message= $this->input->post('message');
    $name = $this->input->post('StudentNames');
    $con_msg = $name ." ". $message;
    log_message("INFO", implode("; ", [trim($NumberTo), $con_msg]));
    $ch = curl_init();
    $parameters = array(
        'apikey' => '24da6cd44efc8df71385f0c1308b6548', //Your API KEY
        'number' => '',
        'message' => $message,
        'sendername' => ''
    );
    curl_setopt( $ch, CURLOPT_URL,'https://semaphore.co/api/v4/messages' );
    curl_setopt( $ch, CURLOPT_POST, 1 );

//Send the parameters set above with the request
    curl_setopt( $ch, CURLOPT_POSTFIELDS, http_build_query( $parameters ) );

// Receive response from server
    curl_setopt( $ch, CURLOPT_RETURNTRANSFER, true );
    $output = curl_exec( $ch );
    curl_close ($ch);

//Show the server response
    echo $output;
}


    function itexmo_sendSingleSms($number,$stdName,$message){

        $ch = curl_init();
        $itexmo = array('1' => $number
                        ,'2' => $message.' '.$stdName
                        ,'3' => 'TR-SCRIB278188_KDXWC');

        curl_setopt($ch, CURLOPT_URL,"https://www.itexmo.com/php_api/api.php");
        curl_setopt($ch, CURLOPT_POST, 1);
        curl_setopt($ch, CURLOPT_POSTFIELDS,
            http_build_query($itexmo));
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_exec($ch);
         curl_close($ch);
         return "Queued Message.";

    }





}
?>