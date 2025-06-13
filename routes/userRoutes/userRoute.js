var express =require("express")
const { createUser, user_info } = require("../../controller/user/userController")
var router =express.Router()

router.get("/logged/user_info",user_info)
router.post("/create",createUser)



module.exports=router