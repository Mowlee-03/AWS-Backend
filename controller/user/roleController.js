const {PrismaClient}=require("@prisma/client")
const prisma=new PrismaClient()



const createRoleWithPermissions = async (req, res) => {
  try {
    const { name, permissionIds } = req.body; // permissionIds = [1, 2, 3]

    const role = await prisma.roles.create({
      data: {
        name,
        permissions: {
          connect: permissionIds.map((id) => ({ id })),
        },
      },
      include: {
        permissions: true,
      },
    });

    res.status(200).json({
      status: 200,
      message: "Role created successfully with permissions",
      data:role,
    });
  } catch (error) {
    console.error(err);
    res.status(500).json({ 
      status:500,
      message:"An internal server error",
      error: error.message 
    });
  }
};

  
const getAllRoles = async (req, res) => {
    try {
      const roles = await prisma.roles.findMany({ include: { permissions: true } });
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
      const { name } = req.body;
      await prisma.roles.update({
        where: { id: Number(id) },
        data: { name }
      });
      res.status(200).json({
        status:200,
        message:"Role name Updated"
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
  

const updateRoleWithPermissions = async (req, res) => {
    const { roleId, permissionIds } = req.body;
  
    if (!roleId || !Array.isArray(permissionIds)) {
      return res.status(400).json({ message: "Invalid request data" });
    }
  
    try {
      // Check if role exists
      const existingRole = await prisma.roles.findUnique({ where: { id: roleId } });
      if (!existingRole) {
        return res.status(404).json({ message: "Role not found" });
      }
  
      // Step 1: Remove all current permissions
      await prisma.rolesPermissions.deleteMany({ where: { roleId } });
  
      // Step 2: Add new permissions
      const data = permissionIds.map((permissionId) => ({
        roleId,
        permissionId,
      }));
  
      await prisma.rolesPermissions.createMany({ data });
  
      res.status(200).json({ message: "Permissions updated successfully" });
    } catch (error) {
      console.error("Error updating permissions:", error);
      res.status(500).json({ message: "Internal server error" });
    }
  };
  
  // RolesPermissions (junction) - assign/remove permission to/from role
const assignPermissionsToRole = async (req, res) => {
    try {
      const { roleId, permissionIds } = req.body; // permissionIds = [1, 2, 3]
      const data = permissionIds.map(permissionId => ({
        roleId,
        permissionId
      }));
      const result = await prisma.rolesPermissions.createMany({ data, skipDuplicates: true });
      res.json(result);
    } catch (err) {
      res.status(500).json({ error: err.message });
    }
  };
  
  
const removePermissionsFromRole = async (req, res) => {
    try {
      const { roleId, permissionIds } = req.body;
      const deletePromises = permissionIds.map(permissionId =>
        prisma.rolesPermissions.delete({
          where: {
            roleId_permissionId: {
              roleId,
              permissionId
            }
          }
        })
      );
      await Promise.all(deletePromises);
      res.json({ message: 'Permissions removed from role' });
    } catch (err) {
      res.status(500).json({ error: err.message });
    }
  };
  


module.exports={
  createRoleWithPermissions,
  getAllRoles,
  updateRole,
  deleteRole,
  updateRoleWithPermissions
}