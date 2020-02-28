//Declare libraries
const express = require('express');
const app = express();
const morgan = require('morgan');
const bodyParser = require('body-parser');

//declare the route file as a variable
const apiRoutes = require('./routes/routes');


//MIDDLEWARE methods

//Declare the packages
app.use(morgan('dev'));
app.use(bodyParser.urlencoded({extended:false}));
app.use(bodyParser.json());

//middleware to allow all connections to the API HANDLE CORS ERRORS
app.use((req,res,next)=>{
    res.header("Access-Control-Allow-Origin","*");
    res.header("Access-Control-Allow-Headers","Origin, X-Requested-With, Content-Type, Accept, Authorization");
    if(req.method === 'OPTIONS'){
        res.header('Access-Control-Allow-Methods','PUT, POST, GET');
        return res.status(200).json({});
    }
    next();
});

// Handle requests in this URL
app.use('/v1',apiRoutes);

//ERROR HANDLING
app.use((req,res,next)=>{
    const error = new Error('Command Not Found. Please Check The Documentation For Correct Syntax.');
    error.status = 404;
    next(error);
});

app.use((error,req,res,next)=>{
    res.status(error.status || 500);
    res.json({
        error:{
            message: error.message
        }
    });
});

//END OF MIDDLEWARE METHODS




module.exports = app;
