const express = require("express");
const router = express.Router();
//import DB
// const Auth = require('../middleware/Auth')
router.get('/', (req,res,next)=>{
    res.status(200).json({
        message : "reached seller"
    });
})

module.exports = router;
