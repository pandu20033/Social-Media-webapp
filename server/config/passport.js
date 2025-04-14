require("dotenv").config(); // Load environment variables
const passport = require("passport");
const JwtStrategy = require("passport-jwt").Strategy;
const ExtractJwt = require("passport-jwt").ExtractJwt;
const jwt = require("jsonwebtoken");
const User = require("../models/user.model");
const Token = require("../models/token.model");

// JWT Strategy options
const opts = {
    jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
    secretOrKey: process.env.SECRET, // Ensure SECRET is set in .env file
};

// Implement the JWT Strategy
passport.use(
    new JwtStrategy(opts, async (jwt_payload, done) => {
        try {
            // Find user by email
            const user = await User.findOne({ email: jwt_payload.email });
            if (!user) {
                return done(null, false); // User not found
            }

            // Check if the refresh token exists in the database
            const refreshTokenFromDB = await Token.findOne({ user: user._id });
            if (!refreshTokenFromDB) {
                return done(null, false); // Refresh token missing
            }

            // Verify the refresh token
            const refreshPayload = jwt.verify(
                refreshTokenFromDB.refreshToken,
                process.env.REFRESH_SECRET
            );

            // Ensure the email in the refresh token matches the JWT payload
            if (refreshPayload.email !== jwt_payload.email) {
                return done(null, false);
            }

            // Check if the token is about to expire
            const tokenExpiration = new Date(jwt_payload.exp * 1000); // Convert UNIX timestamp to milliseconds
            const currentTime = new Date();
            const timeDifference = tokenExpiration.getTime() - currentTime.getTime();

            if (timeDifference > 0 && timeDifference < 30 * 60 * 1000) {
                // Token is about to expire, issue a new token
                const newPayload = {
                    _id: user._id,
                    email: user.email,
                };
                const newToken = jwt.sign(newPayload, process.env.SECRET, {
                    expiresIn: "6h",
                });
                return done(null, { user, newToken }); // Pass user and new token
            }

            // Token is still valid
            return done(null, { user });
        } catch (err) {
            console.error(err); // Log the error for debugging
            return done(err, false);
        }
    })
);