//Declare libraries to be used
const express = require('express');
const timeout = require('connect-timeout');
const router = express.Router();
const request = require('request');
const httpClient = require('urllib');
const bodyParser = require('body-parser');

//Declaring constants
const device = 'COM3';
const modem = require('modem-commands').Modem();
const modemOptions = {
  baudRate: 115200,
  dataBits: 8,
  parity: 'none',
  stopBits: 1,
  flowControl: false,
  xon: false,
  rtscts: false,
  xoff: false,
  xany: false,
  buffersize: 0,
  onNewMessage: true,
  onNewMessageIndicator: true
}


//Get Status of modem
router.get('/status',timeout('10s'),(req,res)=>{

    try{
        modem.open(device,modemOptions, (err,result) => {
            console.log(result)
        })
        modem.initializeModem((response) => {
            console.log('response:',response)
            res.status(200).json({status:response})
        })
    }
    catch(error){
        console.log(error);
        res.status(500).json({status:error});
    }
});

// Check what port
router.get('/whatport',timeout('7s'),(req,res)=>{
    console.log('Checking Port Connections.');
    console.log('Listing Modem Port Location');
    modem.listOpenPorts((err, result)=>{
        console.log(err,result);
    });
});


router.get('/test',(req,res)=>{
    console.log('Creating Test Send.');
    try{
      modem.sendSMS("09175278188", "Test Message", function(response){
        console.log(response)
      },true);
      modem.on('onMessageSent', (data) => {
           console.log(data)
      })
    }catch(e){
      console.log(e)
    }
});

//Send Sms Route
router.get('/sms/send/:mobileContact/message/:messageContent',(req,res)=>{
    //var mobileContact = req.body.mobileContact;
    //var messageContent = req.body.messageContent;

    var mobileContact = req.params.mobileContact;
    var messageContent = req.params.messageContent;

        modem.open(device, modemOptions, (err,results)=>{
            console.log(results);
        });

        modem.initializeModem((response) => {
            console.log(response)
        })

        modem.getModemSerial((response) => {
            console.log(response)
        })

        modem.initializeModem((response) => {
            console.log('response:',response)
            /// Change the Mode of the Modem to SMS or PDU (Callback, "SMS"|"PDU")
            modem.modemMode((response) => {console.log(response)}, "PDU")
            modem.sendSMS(mobileContact, messageContent, function(response){
                console.log('message status ',response)
            }, true);
        });
});





module.exports = router;
