var express = require('express');
var router = express.Router();

const RoleRoute=require("../routes/userRoutes/roleRoute")

router.use("/roles",RoleRoute)


module.exports = router;
