const {PrismaClient} = require("@prisma/client")
const prisma=new PrismaClient()


const createRole = async (req, res) => {
  try {
    const { name,description  } = req.body; 
    if (!name) {
      return res.status(400).json({
        status:400,
        message:"Name is required for role creation"
      })
    }
    const isExist=await prisma.roles.findUnique({where:{name}})
    if (isExist) {
      return res.status(409).json({
        status:409,
        message:"Role already exist"
      })
    }
    const role = await prisma.roles.create({
      data:{
        name,
        description
      }
    })

    res.status(200).json({
      status: 200,
      message: "Role created successfully",
      data:role,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ 
      status:500,
      message:"An internal server error",
      error: error.message 
    });
  }
  };
  
const getAllRoles = async (req, res) => {
    try {
      const roles = await prisma.roles.findMany();
      res.status(200).json({
        status:200,
        message:"Fetching roles success",
        data:roles
      });
    } catch (error) {
      res.status(500).json({ 
        status:500,
        message:"An internal server error",
        error: error.message 
      });
    }
  };
  
const updateRole = async (req, res) => {
    try {
      const { id } = req.params;
      const { name,description } = req.body;
      if (!name) {
        return res.status(400).json({
          status:400,
          message:"Name is required"
        })
      }
      const isExist=await prisma.roles.findUnique({where:{id: Number(id)}})
      if (!isExist) {
        return res.status(409).json({
          status:409,
          message:"Role not found"
        })
      }
      const duplicateRole = await prisma.roles.findFirst({
          where: {
            name,
            NOT: { id: Number(id) }, // prevent false positive if updating the same name
          },
        });

      if (duplicateRole) {
        return res.status(409).json({
          status: 409,
          message: "Role name already exists",
        });
      }
      await prisma.roles.update({
        where: { id: Number(id) },
        data: { 
          name,
          description
        }
      });
      res.status(200).json({
        status:200,
        message:"Role Updated"
      });
    } catch (error) {
      res.status(500).json({
        status:500,
        message:"An internal server error",
         error: error.message 
        });
    }
  };
  
const deleteRole = async (req, res) => {
    try {
      const { id } = req.params;
      await prisma.roles.delete({ where: { id: Number(id) } });
      res.status(200).json({ 
        status:200,
        message: 'Role deleted'
      });
    } catch (err) {
      res.status(500).json({ error: err.message });
    }
  };
  


  


module.exports={
  createRole,
  getAllRoles,
  updateRole,
  deleteRole,
}