const {PrismaClient} = require("@prisma/client");
const { hashPassword } = require("../../utils/password");
const prisma=new PrismaClient()



// Users CRUD
const createUser = async (req, res) => {
    const { 
      full_name,username,email,password,mobile_number,aws_type,aws_date,no_of_site,
      role_id,isChild,parent_id,need_user_limit,sub_user_limit,status
    } = req.body;
    
    try {

      if (!username || !email || !password || !mobile_number || !role_id) {
        return res.status(400).json({
          status:400,
          message:"Required fields missing"
        })
      }

      if (isChild === true && !parent_id) {
        return res.status(400).json({
          status: 400,
          message: "Main user id is required when its sub user"
        });
      }

      if (need_user_limit === true && (!sub_user_limit || sub_user_limit === undefined || sub_user_limit === null)) {
        return res.status(400).json({
          status: 400,
          message: "Enter user limit when you need limit"
        });
      }

      const hashedPass=hashPassword(password)
      await prisma.users.create({

      })
      res.status(200).json({
        status:200,
        message:"User created successfully"
      });
    } catch (error) {
      console.log(error); 
      return res.status(500).json({
                status:500,
                message:"An internal server error", 
                error: error.message 
            });
    }
  };
  
const getAllUsers = async (req, res) => {
    try {
      const users = await prisma.user.findMany({
        include: {
          role: true,
          department: true
        }
      });
      res.status(200).json({
        status:200,
        message:"Fetching Users Successfully",
        data:users
      });
    } catch (error) {
        console.log(error);
        return res.status(500).json({
            status:500,
            message:"An internal server", 
            error: error.message 
        });
    }
};
  
const updateUser = async (req, res) => {
    try {
      const { id } = req.params;
      const { email, username, password, roleId, departmentid } = req.body;

      await prisma.user.update({
        where: { id: Number(id) },
        data: { email, username, password, roleId, departmentid }
      });
      res.status(200).json({
        status:200,
        message:"User updated successfully"
      });
    } catch (error) {
        console.log(error);
        
        return res.status(500).json({
            status:500,
            message:"An internal server error", 
            error: error.message 
        });
    }
  };
  
const deleteUser = async (req, res) => {
    try {
      const { id } = req.params;
      await prisma.user.delete({ where: { id: Number(id) } });
      res.status(200).json({ 
        status:200,
        message: 'User deleted' 
    });
    } catch (error) {
      res.status(500).json({ 
        error: error.message 
    });
    }
  };