# GSM Modem Commands (modem-commands)

## Description
> modem-commands allows you to use your GSM modems on node.  It supports the following
* Sending SMS messages
* Receiving SMS messages
* Message and Command Queue
* Check SIM Card
* Delete all messages in SIM memory

## Installation
```
$ npm install --save modem-comannds
```
## Setting Up

```
Accepts the following options:

let modemOptions = {
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

let modem = require('modem-commands').Modem()

```
## List All Open Ports
```
modem.listOpenPorts((err, result)=>{
  console.log(result)
})

Output:
[ { comName: '/dev/tty.usbserial10',
    manufacturer: undefined,
    serialNumber: undefined,
    pnpId: undefined,
    locationId: undefined,
    vendorId: undefined,
    productId: undefined },
  { comName: '/dev/tty.usbserial',
    manufacturer: undefined,
    serialNumber: undefined,
    pnpId: undefined,
    locationId: undefined,
    vendorId: undefined,
    productId: undefined } ]

```
## Connect to GSM Modem
```

let device = '/dev/tty.usbserial'

modem.open(device,modemOptions, (err,result) => {
  console.log(result)
})

Output:
{ status: 'success',
  request: 'connectModem',
  data: {
    modem: '/dev/tty.usbserial',
    status: 'Online'
  }
}

///Initialize Modem by Sending an AT Command ///
modem.initializeModem((response) => {
  console.log(response)
})

output:
{ status: 'success',
  request: 'modemInitialized',
  data: 'Modem Successfully Initialized' }
```
## Change Modem Mode to SMS or PDU
```
  modem.modemMode((response) => {
    console.log(response)
  }, "PDU")

  output:
  { status: 'success',
  request: 'modemMode',
  data: 'PDU_Mode' }

  modem.modemMode((response) => {
    console.log(response)
  }, "SMS")

  output:
  { stgit checkout masteratus: 'success',
  request: 'modemMode',
  data: 'SMS_Mode' }


```

## Get Modem Serial Number
```
modem.getModemSerial((response) => {
  console.log(response)
})

output:
{ status: 'success',
  request: 'getModemSerial',
  data: { modemSerial: '356995005282463' } }

```
## Get Network signal
```
modem.getNetworkSignal((response) => {
  console.log(response)
})

output:
{ status: 'success',
  request: 'getNetworkSignal',
  data: { signalQuality: '24' } }


Value	RSSI dBm	Condition
2	-109	Marginal
3	-107	Marginal
4	-105	Marginal
5	-103	Marginal
6	-101	Marginal
7	-99	Marginal
8	-97	Marginal
9	-95	Marginal
10	-93	OK
11	-91	OK
12	-89	OK
13	-87	OK
14	-85	OK
15	-83	Good
16	-81	Good
17	-79	Good
18	-77	Good
19	-75	Good
20	-73	Excellent
21	-71	Excellent
22	-69	Excellent
23	-67	Excellent
24	-65	Excellent
25	-63	Excellent
26	-61	Excellent
27	-59	Excellent
28	-57	Excellent
29	-55	Excellent
30	-53	Excellent

```


## Send SMS
```
   modem.sendSMS("09473625384", `Test Message, function(response){
     console.log('message status',response)
   }, true)

   (number, message, callback, priority)
```

## Events

```
modem.on('open', (data) => {
  console.log(data)
});

modem.on('onSendingMessage', (data) => {
  console.log(data)
})

modem.on('onMessageSent', (data) => {
  console.log(data)
})

modem.on('onMessageSendingFailed', (data) => {
  console.log(data)
})

modem.on('onNewMessage', (data) => {
  console.log(data)
})

modem.on('onNewMessageIndicator', (data) => {
  console.log(data)
})

modem.on('onModemActivityStream', (data) => {
  console.log(data)
})



```
