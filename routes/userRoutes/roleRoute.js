var express=require("express")
const { createRole, getAllRoles, updateRole, deleteRole } = require("../../controller/user/roleController")
var router=express.Router()

router.post("/create",createRole)
router.get("/viewall",getAllRoles)
// router.put("/update/:id",updateRole)
// router.delete("/delete/:id",deleteRole)


module.exports=router