var express = require('express');
var router = express.Router();

const RoleRoute=require("../routes/userRoutes/roleRoute")
const UserRoute=require("../routes/userRoutes/userRoute")






router.use("/roles",RoleRoute)
router.use("/users",UserRoute)


module.exports = router;
