const express = require("express");
const router = express.Router();
//import DB
// const Auth = require('../middleware/Auth')

router.get('/', (req,res,next)=>{
    console.log("at employee")
    res.status(200).json({
        message : "reached employee"
    });
})

module.exports = router;