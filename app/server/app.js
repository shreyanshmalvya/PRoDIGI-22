const express = require('express');
const app = express();
const bodyParser = require('body-parser');

//creating and importing routes for scalable architechure
const employeeRoute = require('./api/routes/employee');
const sellerRoute = require('./api/routes/seller');


//databse connection

// using body parser to access form data
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

//handling CORS errors 
app.use((req,res, next)=>{
    //adding origin, header
    console.log('inside cors')
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept, Authorization');
    
    //preflight response
    if(res.method === "OPTIONS"){
        res.header('Access-Control-Allow-Methods', 'GET, POST, PATCH, DELETE');
    }
    next();
})

//routing
app.use('/employee', employeeRoute);
app.use('/seller', sellerRoute);

//handling errors 404 and 500 errors and sending a response
app.use((req, res,next) =>{
    const error = new Error();
    error.status = 404;
    next(error);
});

//funnel for all other errors !404
app.use((error, req,res,next)=>{
    res.status = error.status || 500;
    res.json({
        error : error.message
    });
});

module.exports = app;