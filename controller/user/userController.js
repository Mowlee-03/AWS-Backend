const {PrismaClient} = require("@prisma/client");
const { hashPassword } = require("../../utils/password");
const prisma=new PrismaClient()



const createUser = async (req, res) => {
  let {
    full_name, username, email, password, mobile_number,
    aws_type, aws_date, no_of_site,
    role_id, isChild, parent_id,
    need_user_limit, sub_user_limit, status
  } = req.body;

  const personRoleId = 1; // super admin
  const personId = 1;

  try {
    // Step 1: Basic validations
    if (!username || !email || !password || !mobile_number || !role_id) {
      return res.status(400).json({ status: 400, message: "Required fields missing" });
    }
    
    // Step 2: Role-based validation
    if (personRoleId === 1) {
      if (role_id === 1 && isChild) {
        return res.status(400).json({ status: 400, message: "Super admin cannot be created as child" });
      }
      if (role_id === 2 && isChild) {
        return res.status(403).json({ status: 403, message: "Admin cannot be sub-user under another admin" });
      }
      if (role_id === 3 && (!isChild || !parent_id)) {
        return res.status(400).json({ status: 400, message: "Sub-user must be child with parent_id" });
      }
    }

    if (personRoleId === 2) {
      if (role_id !== 3) {
        return res.status(403).json({ status: 403, message: "Admins can only create sub-users" });
      }
      if (!isChild || Number(parent_id) !== personId) {
        return res.status(403).json({ status: 403, message: "Admins can only create sub-users under themselves" });
      }
    }

    if (personRoleId === 3) {
      return res.status(403).json({ status: 403, message: "Sub-users cannot create users" });
    }

    // Step 3: Check assigned roles exist
    const [creatorRole, assignedRole] = await Promise.all([
      prisma.roles.findUnique({ where: { id: personRoleId }, select: { id: true } }),
      prisma.roles.findUnique({ where: { id: role_id }, select: { id: true } }),
    ]);

    if (!creatorRole) return res.status(403).json({ status: 403, message: "Unauthorized! Creator role not found" });
    if (!assignedRole) return res.status(404).json({ status: 404, message: "Assigned role not found" });

    // Step 4: Logical constraints
    if (isChild && !parent_id) {
      return res.status(400).json({ status: 400, message: "Parent ID required for sub-user" });
    }

    if (need_user_limit && !sub_user_limit) {
      return res.status(400).json({ status: 400, message: "Sub-user limit required when need_user_limit is true" });
    }

    if (isChild && need_user_limit) {
      return res.status(400).json({ status: 400, message: "Sub-users cannot have user limits" });
    }

    // Step 5: Normalize values for super admin
    if (personRoleId === 1 && role_id === 1) {
      isChild = false;
      need_user_limit = false;
      parent_id = null;
    }

    // Step 6: Check parent user and limit
    if (isChild && parent_id) {
      const parentUser = await prisma.users.findUnique({
        where: { id: Number(parent_id) },
        select: {
          id: true,
          need_user_limit: true,
          sub_user_limit: true,
          _count: { select: { sub_users: true } }
        }
      });

      if (!parentUser) {
        return res.status(404).json({ status: 404, message: "Parent user not found" });
      }

      if (parentUser.need_user_limit && parentUser._count.sub_users >= parentUser.sub_user_limit) {
        return res.status(403).json({ status: 403, message: "Sub-user limit reached for this parent" });
      }
    }

    // Step 7: Hash password and create
    const hashedPass = hashPassword(password);

    const newUser = await prisma.users.create({
      data: {
        full_name, username, email, password: hashedPass, mobile_number,
        aws_type, aws_date, no_of_site,
        role_id: Number(role_id),
        isChild: Boolean(isChild),
        parent_id: isChild ? Number(parent_id) : null,
        need_user_limit,
        sub_user_limit: need_user_limit ? Number(sub_user_limit) : null,
        status
      }
    });

    return res.status(200).json({
      status: 200,
      message: "User created successfully",
      data: newUser
    });

  } catch (error) {
    console.error(error);
    return res.status(500).json({
      status: 500,
      message: "Internal server error",
      error: error.message
    });
  }
};









  module.exports ={
    createUser
  }