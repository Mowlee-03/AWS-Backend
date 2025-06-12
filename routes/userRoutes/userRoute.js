var express =require("express")
const { createUser } = require("../../controller/user/userController")
var router =express.Router()

router.post("/create",createUser)



module.exports=router