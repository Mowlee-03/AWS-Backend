const checkPermission = (requiredPermission) => {
    return (req, res, next) => {
        const user = req.user;

        if (!user?.permissions?.includes(requiredPermission)) {
            return res.status(403).json({
                status: 403,
                message: `Forbidden: You don't have permission to ${requiredPermission}.`
            });
        }

        next();
    };
};

module.exports = checkPermission;
