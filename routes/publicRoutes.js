var express =require("express")
const { 
    loginWithEmail, 
    requestMobileOtp, 
    verifyMobileOtp 
} = require("../controller/user/userController")
var router=express.Router()

router.post("/login/email",loginWithEmail)
router.post("/login/mobile/otp_request",requestMobileOtp)
router.post("/login/mobile/otp_verify",verifyMobileOtp)



module.exports=router