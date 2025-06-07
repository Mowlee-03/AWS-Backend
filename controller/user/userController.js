const {PrismaClient}=require("@prisma/client");
const { hashPassword } = require("../../utils/password");
const prisma=new PrismaClient()



// Users CRUD
const createUser = async (req, res) => {
    try {
      const { 
        email, 
        username, 
        password, 
        roleId, 
    } = req.body;
      const isExist=await prisma.findUnique({
        where:{email}
      })
      if (isExist) {
        return res.status(409).json({
            status:409,
            message:"Email already exist"
        })
    }
    const hashedPass=hashPassword(password)
      await prisma.user.create({
        data: {
          email,
          username,
          password:hashedPass,
          roleId,
          departmentid
        }
      });
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