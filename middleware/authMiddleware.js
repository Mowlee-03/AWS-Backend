const { verifyToken } = require("../utils/token");
const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient();

const authMiddleware = async (req, res, next) => {
  try {
    const token = req.cookies.authToken;

    if (!token) {
      return res.status(401).json({ message: "Authentication(token) required" });
    }

    const decodedUser = verifyToken(token);

    if (!decodedUser || !decodedUser.id) {
      return res.status(401).json({ message: "Authorization failed invalid token." });
    }

    const foundedUser = await prisma.users.findUnique({
      where: { id: decodedUser.id },
    });

    if (!foundedUser) {
      return res.status(404).json({ message: "Authorization failed user not found." });
    }

    req.user = decodedUser;

    next();
  } catch (error) {
    console.log(error);
    res.status(401).json({ message: "Unauthorized request." });
  }
};

module.exports = authMiddleware;
