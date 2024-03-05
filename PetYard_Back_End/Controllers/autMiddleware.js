const jwt = require('jsonwebtoken');

const authMiddleware = (req, res, next) => {
    const token = req.headers.authorization;

    if (!token) {
        return res.status(401).json({
            status: "Fail",
            message: "No token provided, authorization denied"
        });
    }

    try {
        // Extract the token from the Authorization header
        const tokenParts = token.split(' ');
        const jwtToken = tokenParts[1]; // Get the actual JWT token


        // Verify the token and extract the payload
        const decoded = jwt.verify(jwtToken,'your_secret_key');


        // Extract the Owner ID from the decoded token
        const ownerId = decoded.owner_id;

        // Attach the Owner ID to the request object for future use
        req.Owner_Id = ownerId;
        console.log( req.Owner_Id );

        // Call the next middleware in the chain
        next();

    } catch (error) {
        console.error("Error verifying token:", error);
        return res.status(401).json({
            status: "Fail",
            message: "Invalid token"
        });
    }
};

module.exports = authMiddleware;
