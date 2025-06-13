var express = require('express');
var router = express.Router();

const RoleRoute=require("../routes/userRoutes/roleRoute")
const UserRoute=require("../routes/userRoutes/userRoute");
const authMiddleware = require('../middleware/authMiddleware');






router.use("/roles",authMiddleware,RoleRoute)
router.use("/users",authMiddleware,UserRoute)


module.exports = router;
