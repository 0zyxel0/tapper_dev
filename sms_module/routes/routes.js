//Declare libraries to be used
const express = require('express');
const timeout = require('connect-timeout');
const router = express.Router();
const request = require('request');
const httpClient = require('urllib');
const bodyParser = require('body-parser');

//Declaring constants
const device = 'COM1';
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
router.get('/status',timeout('5s'),(req,res)=>{
  console.log('Check Modem Status');
});

// Check what port
router.get('/whatport',timeout('7s'),(req,res)=>{
    console.log('Checking Port Connections.');
    console.log('Listing Modem Port Location');
    modem.listOpenPorts((err, result)=>{
        console.log(err,result);
    });
});

//Send Sms Route
router.get('/sms/send/:mobileContact/message/:messageContent',(req,res)=>{
    //var mobileContact = req.body.mobileContact;
    //var messageContent = req.body.messageContent;

    var mobileContact = req.params.mobileContact;
    var messageContent = req.params.messageContent;


    // if (!modem.isOpened) {
    //     modem.open(device,modemOptions, (err,result) => {
    //         if(err){
    //             console.log(err)
    //             console.log('Closing Connection');
    //         }else{
    //             console.log(result)
    //         }
    //     })
    // } else {
    //     console.log(`Serial port ${modem.port.path} is open`);
    // }

    modem.on('open', (data) => {
        modem.initializeModem((response) => {
            console.log('response:',response)
            /// Change the Mode of the Modem to SMS or PDU (Callback, "SMS"|"PDU")
            modem.modemMode((response) => {console.log(response)}, "PDU")
            // modem.getModemSerial((response) => {
            //     console.log(response)
            // })
            // modem.getNetworkSignal((response) => {
            //     console.log('Network Signal : ',response);
            // })
            modem.sendSMS(mobileContact, messageContent, function(response){
                console.log('message status ',response)
            }, true);
        })
    });

    // setTimeout(() => {
    //     modem.close(() => process.exit);
    // }, 5000);

});





module.exports = router;
