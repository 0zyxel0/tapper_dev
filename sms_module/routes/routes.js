//Declare libraries to be used
const express = require('express');
const timeout = require('connect-timeout');
const router = express.Router();
const request = require('request');
const httpClient = require('urllib');
const bodyParser = require('body-parser');

//Declaring constants
const device = 'COM5';
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




module.exports = router;
