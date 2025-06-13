const {PrismaClient} = require("@prisma/client");
const { hashPassword, verifyPassword } = require("../../utils/password");
const { generateToken, setCookie } = require("../../utils/token");
const prisma=new PrismaClient()



const createUser = async (req, res) => {
  let {
    full_name, username, email, password, mobile_number,
    aws_type, aws_date, no_of_site,
    role_id, isChild, parent_id,
    need_user_limit, sub_user_limit, status
  } = req.body;

  const personRoleId = req.user?.role_id; 
  const personId = req.user?.id;
  console.log(personId,personRoleId);
  
  if (!personId || !personRoleId) {
    return res.status(403).json({
      status:403,
      message:"Forbidden to create user"
    })
  }
  if (personRoleId!==1 && personRoleId!==2) {
    return res.status(401).json({
      status:401,
      message:"You have not access to create user"
    })
  }
  try {
    // Step 1: Basic validations
    if (!username || !email || !password || !mobile_number || !role_id) {
      return res.status(400).json({ status: 400, message: "Required fields missing" });
    }

    const isUserNameExist=await prisma.users.findUnique({
      where:{username:username}
    })
    if (isUserNameExist) {
      return res.status(409).json({
        status:409,
        message:"Username already exist ,try unique"
      })
    }
    const isEmailExist=await prisma.users.findUnique({
      where:{email:email}
    })
    if (isEmailExist) {
      return res.status(409).json({
        status:409,
        message:"Email already exist ,try unique"
      })
    }
    const isMobileNumberExist=await prisma.users.findUnique({
      where:{mobile_number:mobile_number}
    })
    if (isMobileNumberExist) {
      return res.status(409).json({
        status:409,
        message:"Mobile number already exist,try unique"
      })
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

const user_info=async(req, res) => {  
  try {
    const token = req.cookies.authToken; // Get the token from the cookie
    if (!token) {
    return res.status(401).json({ error: 'No token provided' });
  }
    const decoded_user=verifyToken(token)
    if (decoded_user.error) {
        return res.status(403).json({
            status:403,
            message:decoded_user.error
        })
    }
    res.status(200).json({
        status:200,
        message:"User Fetched Successfully",
        data:decoded_user
    })
    
  } catch (error) {
    res.status(500).json({ 
        status:500,
        message: 'Invalid token or internal server error' ,
        err:error.message
    });
  }
}



//Public Routes
const loginWithEmail=async (req,res) => {
  const {email,password}=req.body
  if (!email|| !password) {
    return res.status(400).json({
      status:400,
      message:"Fill required fields"
    })
  }

  try {
    const user=await prisma.users.findUnique({
      where:{email:email},
      select:{
        id:true,
        full_name:true,
        username:true,
        email:true,
        password:true
      },
      include:{
        role:{
          select:{
            id:true,
            name:true,
          }
        }
      }
    })
    if (!user) {
      return res.status(404).json({
        status:404,
        message:"User not found in this email"
      })
    }
    const verifyPass =await verifyPassword(password,user.password)
    if (!verifyPass) {
      return res.status(403).json({ status: 403, message: "Invalid Password" });
    }
    const role=user.role?.name||null;
    const role_id=user.role?.id

    const token =generateToken({
      id:user.id,
      username:user.username,
      full_name:user.full_name,
      email:user.email,
      role:role,
      role_id:role_id
    })
    // Set authentication cookie
    setCookie(res,'authToken',token)
    return res.status(200).json({
      status:200,
      message:'Login Successfull'
    })
  } catch (error) {
    console.error(error)
    return res.status(500).json({
      status:500,
      message:"Internal server error",
      error:error.message
    })
  }
}

const requestMobileOtp =async (req,res) => {
  const {mobile_number}=req.body
  if (!mobile_number) {
    return res.status(400).json({
      status:400,
      message:"Mobile number is required for login"
    })
  }
  try {
    const user=await prisma.users.findUnique({
      where:{mobile_number},
      select:{
        mobile_number
      }
    })
    if (!user) {
      return res.status(404).json({
        status:404,
        message:"User not found with this mobile number"
      })
    }
    // Generate 5-digit OTP
    const otp = Math.floor(10000 + Math.random() * 90000).toString();
    setCookie(res,"otpToken",otp, 2 * 60 * 1000)
    return res.status(200).json({
      status:200,
      message:"OTP sent successfully"
    })
  } catch (error) {
      console.error(error)
      return res.status(500).json({
        status:500,
        message:"Internal server error",
        error:error.message
      })
  }
}

const verifyMobileOtp = async (req, res) => {
  const { mobile_number,enteredOtp } = req.body;
  const savedOtp = req.cookies.otpToken;

  if (!mobile_number || !enteredOtp) {
    return res.status(400).json({
      status: 400,
      message: "Mobile number and OTP are required",
    });
  }

  if (!savedOtp) {
    return res.status(403).json({
      status: 403,
      message: "OTP expired or not set try again",
    });
  }

  if (savedOtp !== enteredOtp) {
    return res.status(401).json({
      status: 401,
      message: "Invalid OTP",
    });
  }

  try {
    const user = await prisma.users.findUnique({
      where: { mobile_number },
      include: {
        role: { select: { id: true, name: true } },
      },
    });

    if (!user) {
      return res.status(404).json({
        status: 404,
        message: "User not found",
      });
    }

    // Create Auth Token
    const token = generateToken({
      id: user.id,
      username: user.username,
      full_name: user.full_name,
      email: user.email,
      role: user.role?.name,
      role_id: user.role?.id,
    });

    // Set authToken cookie and clear otpToken
    setCookie(res, "authToken", token);
    res.clearCookie("otpToken");

    return res.status(200).json({
      status: 200,
      message: "Login successful via OTP",
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({
      status: 500,
      message: "Internal server error",
    });
  }
};

module.exports ={
  createUser,
  user_info,
  loginWithEmail,
  requestMobileOtp,
  verifyMobileOtp,

}