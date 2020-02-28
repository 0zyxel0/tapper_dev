//Declare Libraries
const express      = require('express');
const bodyParser   = require('body-parser');
const morgan       = require('morgan');



//configure the middlewares to be used


  app.use(morgan('dev'));
  app.use(bodyParser.urlencoded({extended:false}));
  app.use(bodyParser.json());



// middleware to allow all kinds of Connections
app.use((req,res,next)=>{
    res.header("Access-Control-Allow-Origin","*");
    res.header("Access-Control-Allow-Headers","Origin, X-Requested-With, Content-Type, Accept, Authorization");
    if(req.method === 'OPTIONS'){
        res.header('Access-Control-Allow-Methods','PUT, POST, GET');
        return res.status(200).json({});
    }
    next();
});




//This function is checking what port is the modem plugged.
function checkUsbPorts(){
	modem.listOpenPorts((err, result)=>{
	  console.log(result)
	})
}


app.post('/send',(req, res,next)=>{
  var mobileContact = req.body.mobileContact;
  var messageContent = req.body.messageContent;

console.log(mobileContact);
  if(!mobileContact)
  {
    return res.status(400).send({
      error: 'Invalid Mobile Number',
      message: 'Please check the mobile number indicated if it is correct.'
    });
  }
  else {
      //Return success message
    res.status(200).json({
      status:'Sending Message',
      messageBlock: messageContent,
      sendingTo: mobileContact
    });
  }

  // Error Handler
  const responseHandler = (error,data,res)=>{
      if(error){
          console.log(error);
      }
      else{
      console.log(res.statusCode);
      console.log(res.headers);
      console.log(data.toString('utf-8'));
      }
  }

});



//Find Port Route Request

app.get('/whatport',(req,res)=>{
  console.log('Checking Port Connections.');
  console.log('Listing Modem Port Location');
  modem.listOpenPorts((err, result)=>{
    console.log(result);
  });
});

//Get Status of modem
app.get('/status',(req,res)=>{
  console.log('Check Modem Status');

});

//Send Sms Route
app.post('/sms',(req,res)=>{
  var mobileContact = req.body.mobileContact;
  var messageContent = req.body.messageContent;

  if (!modem.isOpened) {
    modem.open(device,modemOptions, (err,result) => {
      if(err){
        console.log(err)
        console.log('Closing Connection');
      }else{
        console.log(result)
      }
    })
  } else {
    console.log(`Serial port ${modem.port.path} is open`);
  }

modem.on('open', (data) => {
  modem.initializeModem((response) => {
    console.log('response:',response)
		/// Change the Mode of the Modem to SMS or PDU (Callback, "SMS"|"PDU")
		  modem.modemMode((response) => {console.log(response)}, "PDU")
		  modem.getModemSerial((response) => {
		    console.log(response)
		  })
		  modem.getNetworkSignal((response) => {
		    console.log('Network Signal : ',response);
		  })
				modem.sendSMS("09088179755", 'This is a school Tap Test!', function(response){
     		console.log('message status ',response)
   			}, true);
	})
});

setTimeout(() => {
  modem.close(() => process.exit);
}, 5000);

});



app.listen(8991,()=>console.log('Tapper Node Listening on port 8991'));
