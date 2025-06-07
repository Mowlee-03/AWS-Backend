const {PrismaClient}=require("@prisma/client")
const prisma=new PrismaClient()

const createPermission = async (req, res) => {
    try {
      const { action } = req.body;
      const isExist =await prisma.permissions.findFirst({
        where:{action}
      })
      if (isExist) {
        return res.status(409).json({
            status:409,
            message:"Permission already exist"
        })
      }
     await prisma.permissions.create({ data: { action } });
      res.status(200).json({
        status:200,
        message:"permission created successfully"
      });
    } catch (error) {
        console.log(error);
        return res.status(500).json({
            status:500,
            message:"An internal server error",
            error:error.message
        })
    }
  };
  
const getAllPermissions = async (req, res) => {
    try {
      const permissions = await prisma.permissions.findMany();
      res.status(200).json({
        status:200,
        message:"Fetching permissions success",
        data:permissions
      });
    } catch (error) {
        console.log(error);
        return res.status(500).json({
            status:500,
            message:"An internal server error",
            error:error.message
        })
    }
  };
  
const updatePermission = async (req, res) => {
    try {
      const { id } = req.params;
      const { action } = req.body;
        await prisma.permissions.update({
        where: { id: Number(id) },
        data: { action }
      });
      res.status(200).json({
        status:200,
        message:"Permission updated"
      });
    } catch (error) {
        console.log(error);
        return res.status(500).json({
            status:500,
            message:"An internal server error",
            error:error.message
        })
    }
  };
  
const deletePermission = async (req, res) => {
    try {
      const { id } = req.params;
      await prisma.permissions.delete({ where: { id: Number(id) } });
      res.status(200).json({ 
        satus:200,
        message: 'Permission deleted' 
    });
    } catch (err) {
      res.status(500).json({ error: err.message });
    }
  };


module.exports={
    createPermission,
    getAllPermissions,
    updatePermission,
    deletePermission
}