const http = require('http');
const app = require('./app');
const port = process.env.PORT || 8991;
const server = http.createServer(app);
server.listen(port);
console.log('Tapper SMS Service Started');
console.log('Tapper SMS Api Service located in http://127.0.0.1:'+port+'/v1');
