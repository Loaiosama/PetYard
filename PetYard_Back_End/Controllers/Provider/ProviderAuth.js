const pool = require('../../db');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const axios = require('axios');
const multer = require('multer');
const sharp = require('sharp');
const saltRounds = 10;
const crypto = require('crypto');//reset pass - forget pass
const Model = require('./../../Models/UserModel');
const sendemail = require("./../../Utils/email");

const multerStorage = multer.memoryStorage();
// const multerFilter = (req, file, cb) => {
//     if (file.mimetype.startsWith('image')) {
//         cb(null, true);
//     }
//     else {
//         cb("Not an image! please upload only images.", false)
//     }
// }
// const multerFilter = (req, file, cb) => {
//     // Check if the file is an image by mimetype or file extension
//     if (file.mimetype.startsWith('image') || ['jpg', 'jpeg', 'png', 'gif'].includes(file.originalname.split('.').pop().toLowerCase())) {
//         cb(null, true); // Accept the file
//     } else {
//         cb("File format not supported! Please upload only images.", false); // Reject the file
//     }
// }


// const upload = multer({

//     storage: multerStorage,
//     fileFilter: multerFilter
// });
// const uploadphoto = upload.single('Image');
// const resizePhoto = (req, res, next) => {

//     if (!req.file) return next();

//     req.file.filename = `Provider-${req.ID}-${Date.now()}.jpeg`;

//     // sharp(req.file.buffer).resize(500, 500).toFormat('jpeg').jpeg({ quality: 90 }).toFile(`public/img/users/ServiceProvider/${req.file.filename}`);
//     sharp(req.file.buffer).resize(500, 500).toFormat('jpeg').jpeg({ quality: 90 }).toFile(`../petowner_frontend/assets/images/profile_pictures/${req.file.filename}`);
//     sharp(req.file.buffer).resize(500, 500).toFormat('jpeg').jpeg({ quality: 90 }).toFile(`../petprovider_frontend/assets/images/profile_pictures/${req.file.filename}`);
//     // sharp(req.file.buffer).resize(500, 500).toFormat('jpeg').jpeg({ quality: 90 }).toFile(`../petprovider_frontend/assets/profile_pictures${req.file.filename}`);
//     next();
// }







// const signUp = async (req, res) => {
//     const { UserName, pass, email, phoneNumber, dateOfBirth, Bio } = req.body;
//     let Image = req.files && req.files.Image ? req.files.Image[0].filename : 'default.png';
//     console.log(Image);
//     try {
//         if (!UserName || !pass || !email || !phoneNumber || !dateOfBirth || !Bio) {
//             return res.status(400).json({
//                 status: "Fail",
//                 message: "Please Fill All Information"
//             });
//         }

//         // Phone number validation
//         const phoneRegex = /^\d+$/;
//         if (!phoneRegex.test(phoneNumber)) {
//             return res.status(400).json({
//                 status: "Fail",
//                 message: "Phone number must consist of only digits"
//             });
//         }

//         // Age validation
//         const birthDate = new Date(dateOfBirth);
//         const today = new Date();
//         const age = today.getFullYear() - birthDate.getFullYear();
//         const monthDiff = today.getMonth() - birthDate.getMonth();
//         const dayDiff = today.getDate() - birthDate.getDate();
//         if (age < 18 || (age === 18 && (monthDiff < 0 || (monthDiff === 0 && dayDiff < 0)))) {
//             return res.status(400).json({
//                 status: "Fail",
//                 message: "User must be at least 18 years old"
//             });
//         }

//         const client = await pool.connect();

//         // Check if UserName, Email, or Phone already exist in the serviceprovider table
//         const userNameExistsQuery = 'SELECT * FROM serviceprovider WHERE UserName = $1';
//         const emailExistsQuery = 'SELECT * FROM serviceprovider WHERE Email = $1';
//         const phoneExistsQuery = 'SELECT * FROM serviceprovider WHERE Phone = $1';

//         const resultUserNameExists = await client.query(userNameExistsQuery, [UserName]);
//         const resultEmailExists = await client.query(emailExistsQuery, [email]);
//         const resultPhoneExists = await client.query(phoneExistsQuery, [phoneNumber]);

//         if (resultUserNameExists.rows.length > 0) {
//             return res.status(400).json({ message: "User Name already exists, try another User Name." });
//         }

//         if (resultEmailExists.rows.length > 0 && resultPhoneExists.rows.length > 0) {
//             return res.status(400).json({ message: "User already exists, try another Email and Phone number." });
//         }

//         if (resultEmailExists.rows.length > 0) {
//             return res.status(400).json({ message: "Email already exists, try another Email." });
//         }

//         if (resultPhoneExists.rows.length > 0) {
//             return res.status(400).json({ message: "Phone number already exists, try another Phone number." });
//         }


//         const userNameExistsQuery1 = 'SELECT * FROM temp_provider WHERE UserName = $1';
//         const emailExistsQuery1 = 'SELECT * FROM temp_provider WHERE Email = $1';
//         const phoneExistsQuery1 = 'SELECT * FROM temp_provider WHERE Phone = $1';

//         const resultUserNameExists1 = await client.query(userNameExistsQuery1, [UserName]);
//         const resultEmailExists1 = await client.query(emailExistsQuery1, [email]);
//         const resultPhoneExists1 = await client.query(phoneExistsQuery1, [phoneNumber]);

//         if (resultUserNameExists1.rows.length > 0) {
//             return res.status(400).json({ message: "Check your email you have validation code" });
//         }

//         if (resultEmailExists1.rows.length > 0 && resultPhoneExists1.rows.length > 0) {
//             return res.status(400).json({ message: "Check your email you have validation code." });
//         }

//         if (resultEmailExists1.rows.length > 0) {
//             return res.status(400).json({ message: "Check your email you have validation code." });
//         }

//         if (resultPhoneExists1.rows.length > 0) {
//             return res.status(400).json({ message: "Check your email you have validation code." });
//         }



//         // Insert new user into temp_provider table
//         const hashedPassword = await bcrypt.hash(pass, saltRounds);
//         const { validationCode } = Model.CreateValidationCode();

//         const insertQuery = `
//             INSERT INTO temp_provider (UserName, Password, Email, Phone, Date_of_birth, Bio, Image, ValidationCode)
//             VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
//             RETURNING *
//         `;
//         const newUser = await client.query(insertQuery, [UserName, hashedPassword, email, phoneNumber, dateOfBirth, Bio, Image, validationCode]);

//         // Send validation code via email
//         await sendemail.sendemail({
//             email: email,
//             subject: 'Your Validation code (valid for 10 min)',
//             message: `Your Validation code ${validationCode} \n Insert the Validation code to enjoy with Our Services`
//         });

//         res.status(201).json({ message: "Sign up successful" });

//         client.release();

//     } catch (error) {
//         console.error("Error during signUp", error);
//         res.status(500).json({ error: "Internal server error" });
//     }
// };

// const validateAndTransfer = async (req, res) => {
//     const { email, validationCode } = req.body;

//     try {
//         const client = await pool.connect();

//         // Check if the validation code exists and is valid
//         const query = 'SELECT * FROM temp_provider WHERE Email = $1 AND ValidationCode = $2 AND ValidationCodeExpires > CURRENT_TIMESTAMP';
//         const result = await client.query(query, [email, validationCode]);

//         if (result.rows.length === 0) {
//             return res.status(400).json({
//                 status: "Fail",
//                 message: "Invalid or expired validation code"
//             });
//         }

//         // Insert the validated provider into the ServiceProvider table
//         const providerData = result.rows[0];
//         const insertQuery = 'INSERT INTO ServiceProvider (UserName, Password, Email, Phone, Date_of_birth, Bio, Image) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *';
//         await client.query(insertQuery, [providerData.username, providerData.password, providerData.email, providerData.phone, providerData.date_of_birth, providerData.bio, providerData.image]);

//         // Delete the provider from temp_provider after successful transfer
//         const deleteQuery = 'DELETE FROM temp_provider WHERE Email = $1';
//         await client.query(deleteQuery, [email]);

//         res.status(200).json({ message: "Provider validated and transferred successfully" });

//         client.release();

//     } catch (error) {
//         console.error("Error validating and transferring provider:", error);
//         res.status(500).json({ error: "Internal server error" });
//     }
// };

// const multerFilter = (req, file, cb) => {
//     if (file.mimetype.startsWith('image')) {
//         cb(null, true);
//     }
//     else {
//         cb("Not an image! please upload only images.", false)
//     }
// }
const multerFilter = (req, file, cb) => {
    // Check if the file is an image by mimetype or file extension
    if (file.mimetype.startsWith('image') || ['jpg', 'jpeg', 'png', 'gif'].includes(file.originalname.split('.').pop().toLowerCase())) {
        cb(null, true); // Accept the file
    } else {
        cb("File format not supported! Please upload only images.", false); // Reject the file
    }
}
const upload = multer({
    storage: multerStorage,
    fileFilter: multerFilter
});
const uploadphoto = upload.single('Image');
const resizePhoto = (req, res, next) => {
    if (!req.file) return next();
    req.file.filename = `Provider-${req.ID}-${Date.now()}.jpeg`;
    // sharp(req.file.buffer).resize(500, 500).toFormat('jpeg').jpeg({ quality: 90 }).toFile(`public/img/users/ServiceProvider/${req.file.filename}`);
    sharp(req.file.buffer).resize(500, 500).toFormat('jpeg').jpeg({ quality: 90 }).toFile(`../petowner_frontend/assets/images/profile_pictures/${req.file.filename}`);
    sharp(req.file.buffer).resize(500, 500).toFormat('jpeg').jpeg({ quality: 90 }).toFile(`../petprovider_frontend/assets/images/profile_pictures/${req.file.filename}`);
    // sharp(req.file.buffer).resize(500, 500).toFormat('jpeg').jpeg({ quality: 90 }).toFile(`../petprovider_frontend/assets/profile_pictures${req.file.filename}`);
    next();
}


const signUp = async (req, res) => {
    const { UserName, pass, email, phoneNumber, dateOfBirth, Bio } = req.body;
    let Image = req.file ? req.file.filename : 'default.png';
    try {
        if (!UserName || !pass || !email || !phoneNumber || !dateOfBirth || !Bio || !Image) {
            return res.status(400).json({
                status: "Fail",
                message: "Please Fill All Information"
            });
        }
        // Phone number validation
        const phoneRegex = /^\d+$/;
        if (!phoneRegex.test(phoneNumber)) {
            return res.status(400).json({
                status: "Fail",
                message: "Phone number must consist of only digits"
            });
        }
        // Age validation
        const birthDate = new Date(dateOfBirth);
        const today = new Date();
        const age = today.getFullYear() - birthDate.getFullYear();
        const monthDiff = today.getMonth() - birthDate.getMonth();
        const dayDiff = today.getDate() - birthDate.getDate();
        if (age < 18 || (age === 18 && (monthDiff < 0 || (monthDiff === 0 && dayDiff < 0)))) {
            return res.status(400).json({
                status: "Fail",
                message: "User must be at least 18 years old"
            });
        }
        const client = await pool.connect();
        // Check if UserName, Email, or Phone already exist in the serviceprovider table
        const userNameExistsQuery = 'SELECT * FROM serviceprovider WHERE UserName = $1';
        const emailExistsQuery = 'SELECT * FROM serviceprovider WHERE Email = $1';
        const phoneExistsQuery = 'SELECT * FROM serviceprovider WHERE Phone = $1';
        const resultUserNameExists = await client.query(userNameExistsQuery, [UserName]);
        const resultEmailExists = await client.query(emailExistsQuery, [email]);
        const resultPhoneExists = await client.query(phoneExistsQuery, [phoneNumber]);
        if (resultUserNameExists.rows.length > 0) {
            return res.status(400).json({ message: "User Name already exists, try another User Name." });
        }
        if (resultEmailExists.rows.length > 0 && resultPhoneExists.rows.length > 0) {
            return res.status(400).json({ message: "User already exists, try another Email and Phone number." });
        }
        if (resultEmailExists.rows.length > 0) {
            return res.status(400).json({ message: "Email already exists, try another Email." });
        }
        if (resultPhoneExists.rows.length > 0) {
            return res.status(400).json({ message: "Phone number already exists, try another Phone number." });
        }
        // Insert new user into temp_provider table
        const hashedPassword = await bcrypt.hash(pass, saltRounds);
        const { validationCode } = Model.CreateValidationCode();
        const insertQuery = `
            INSERT INTO temp_provider (UserName, Password, Email, Phone, Date_of_birth, Bio, Image, ValidationCode)
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
            RETURNING *
        `;
        const newUser = await client.query(insertQuery, [UserName, hashedPassword, email, phoneNumber, dateOfBirth, Bio, Image, validationCode]);
        // Send validation code via email
        await sendemail.sendemail({
            email: email,
            subject: 'Your Validation code (valid for 10 min)',
            message: `Your Validation code ${validationCode} \n Insert the Validation code to enjoy with Our Services`
        });
        res.status(201).json({ message: "Sign up successful" });
        client.release();
    } catch (error) {
        console.error("Error during signUp", error);
        res.status(500).json({ error: "Internal server error" });
    }
};
const validateAndTransfer = async (req, res) => {
    const { email, validationCode } = req.body;
    try {
        const client = await pool.connect();
        // Check if the validation code exists and is valid
        const query = 'SELECT * FROM temp_provider WHERE Email = $1 AND ValidationCode = $2 AND ValidationCodeExpires > CURRENT_TIMESTAMP';
        const result = await client.query(query, [email, validationCode]);
        if (result.rows.length === 0) {
            return res.status(400).json({
                status: "Fail",
                message: "Invalid or expired validation code"
            });
        }
        // Insert the validated provider into the ServiceProvider table
        const providerData = result.rows[0];
        const insertQuery = 'INSERT INTO ServiceProvider (UserName, Password, Email, Phone, Date_of_birth, Bio, Image) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *';
        await client.query(insertQuery, [providerData.username, providerData.password, providerData.email, providerData.phone, providerData.date_of_birth, providerData.bio, providerData.image]);
        // Delete the provider from temp_provider after successful transfer
        const deleteQuery = 'DELETE FROM temp_provider WHERE Email = $1';
        await client.query(deleteQuery, [email]);
        res.status(200).json({ message: "Provider validated and transferred successfully" });
        client.release();
    } catch (error) {
        console.error("Error validating and transferring provider:", error);
        res.status(500).json({ error: "Internal server error" });
    }
};

const signIn = async (req, res) => {

    const { UserName, password } = req.body;

    try {
        // Check if both email and password are provided
        if (!UserName || !password) {
            return res.status(400).json({
                status: "Fail",
                message: "Please provide UserName and password"
            });
        }

        // Query the database for the user with the provided email and password
        const result = await pool.query('SELECT * FROM ServiceProvider WHERE UserName = $1', [UserName]);

        // If user not found
        if (result.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "Incorrect UserName or password"
            });
        }

        // Check if the password matches
        const user = result.rows[0];

        const isPasswordMatch = await bcrypt.compare(password, user.password);


        if (!isPasswordMatch) {
            return res.status(401).json({
                status: "Fail",
                message: "Incorrect email or password"
            });
        }

        // Extract the Provider ID from the query result
        const ProviderId = user.provider_id;
        // Generate a JWT token based on the ProviderId ID
        const token = jwt.sign({ ID: ProviderId }, 'your_secret_key', { expiresIn: '24h' });

        // Send the token back to the client
        res.status(200).json({
            status: "Success",
            token
        });


    } catch (error) {
        console.error("Error signing in:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
}
const deleteAccount = async (req, res) => {

    const provider_id = req.ID;

    try {


        const Query = 'SELECT * FROM ServiceProvider WHERE Provider_Id = $1';
        const result = await pool.query(Query, [provider_id]);

        if (result.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "User doesn't exist."
            });
        }

        const deleteQuery = 'DELETE FROM ServiceProvider WHERE Provider_Id = $1';
        await pool.query(deleteQuery, [provider_id]);

        res.status(200).json({
            status: "Success",
            message: "Account deleted successfully"
        });
    } catch (error) {
        console.error("Error deleting account:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
};
const updateInfo = async (req, res) => {

    const provider_id = req.ID;
    const { UserName, pass, email, phoneNumber, dateOfBirth } = req.body;
    const Image = req.file.filename;

    try {


        if (!UserName || !pass || !email || !phoneNumber || !dateOfBirth) {
            return res.status(400).json({
                status: "Fail",
                message: "Please Fill All Information"
            });
        }

        const Query = 'SELECT * FROM ServiceProvider WHERE Provider_Id = $1';
        const result = await pool.query(Query, [provider_id]);

        if (result.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "User doesn't exist"
            });
        }

        const hashedPassword = await bcrypt.hash(pass, saltRounds);


        const updateQuery = 'UPDATE ServiceProvider SET UserName =$1,  Password = $2, Email = $3, Phone = $4, Date_of_birth = $5 , Image=$6 WHERE Provider_Id = $7';
        await pool.query(updateQuery, [UserName, hashedPassword, email, phoneNumber, dateOfBirth, Image, provider_id]);

        res.status(200).json({
            status: "Success",
            message: "Account info updated successfully"
        });

    }
    catch (error) {
        console.error("Error updating account info:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
};



const forgotPassword = async (req, res) => {
    const { email } = req.body;

    try {
        if (!email) {
            return res.status(400).json({
                status: "Fail",
                message: "Please Fill Your Email"
            });
        }

        const result = await pool.query('SELECT * FROM ServiceProvider WHERE Email = $1', [email]);

        if (result.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "Incorrect email"
            });
        }

        const { resetToken, PasswordResetToken } = Model.CreatePasswordResetToken();

        await pool.query('UPDATE ServiceProvider SET ResetToken = $1 WHERE Email = $2', [PasswordResetToken, email]);

        const resetURL = `${req.protocol}://${req.get('host')}/Provider/Resetpassword/${resetToken}`;

        const message = `Forgot Your password? Submit A put request with your new password to: ${resetURL}.\n If you didnt forget your password, please ignore this email!`;

        await sendemail.sendemail({
            email: email,
            subject: 'Your password reset token (valid for 10 min) ',
            message
        });

        res.status(200).json({
            status: 'success',
            message: 'Token sent to email!'
        });

    } catch (error) {

        console.error("Error sending email:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });

    }
}

const resetPassword = async (req, res) => {

    const { token } = req.params;
    const { pass, email } = req.body;
    const hashedToken1 = crypto.createHash('sha256').update(token).digest('hex');
    const { PasswordResetExpires } = Model.CreatePasswordResetToken();
    try {

        if (!pass || !email) {
            return res.status(400).json({
                status: "Fail",
                message: "Please Fill All Information"
            });

        }
        const result = await pool.query('SELECT * FROM ServiceProvider WHERE Email = $1', [email]);
        const hashedToken2 = result.rows[0].resettoken;
        ;


        if (!hashedToken2) {
            return res.status(400).json({
                status: "Fail",
                message: "No password reset token found for this email"
            });
        }

        if (!hashedToken2 || hashedToken2 !== hashedToken1 || PasswordResetExpires < Date.now()) {
            return res.status(400).json({
                status: "Fail",
                message: "Token is invalid or has expired"
            });
        }
        const hashedPassword = await bcrypt.hash(pass, saltRounds);
        const newpass = 'UPDATE ServiceProvider SET Password = $1 , ResetToken = NULL WHERE Email = $2';
        await pool.query(newpass, [hashedPassword, email]);
        res.status(200).json({ message: "Password Changed correctly" });

    } catch (error) {

        res.status(500).json({ error: "Internal server error" });
    }
}




















const SelectServices = async (req, res) => {
    const provider_id = req.ID;
    const { Type } = req.body;

    try {
        if (!Type) {
            return res.status(400).json({
                status: "Fail",
                message: "Please provide the service type"
            });
        }

        const providerQuery = 'SELECT * FROM ServiceProvider WHERE Provider_Id = $1';
        const providerResult = await pool.query(providerQuery, [provider_id]);

        if (providerResult.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "User doesn't exist."
            });
        }

        const getServiceQuery = 'SELECT * FROM Services WHERE Provider_ID = $1';
        const servicesResult = await pool.query(getServiceQuery, [provider_id]);

        const services = servicesResult.rows;

        // Check if the service type already exists for the provider
        const isServiceAlreadySelected = services.some(service => service.type === Type);
        if (isServiceAlreadySelected) {
            return res.status(400).json({
                status: "Fail",
                message: `You have already selected this service before: ${Type}`
            });
        }

        // Add the new service to the database
        const addServiceQuery = 'INSERT INTO Services (Type, Provider_ID) VALUES ($1, $2) RETURNING *';
        const client = await pool.connect();
        const addedService = await client.query(addServiceQuery, [Type, provider_id]);
        client.release();

        res.status(201).json({
            status: "Success",
            message: "Service added successfully",
            service: addedService.rows[0]
        });

    } catch (error) {
        console.error("Error adding service:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
};



const Killservice = async (req, res) => {
    const provider_id = req.ID;
    const { Service_ID } = req.params;

    try {
        if (!Service_ID) {
            return res.status(400).json({
                status: "Fail",
                message: "Please Fill All Information"
            });
        }
        else {



            const client = await pool.connect();
            const Exists = 'Select * FROM Services WHERE provider_id = $1';
            const result = await client.query(Exists, [provider_id]);

            if (result.rows.length === 0) {
                return res.status(401).json({
                    status: "Fail",
                    message: "Provider doesn't exist"
                });
            }

            const deleteQuery = 'DELETE FROM Services WHERE Service_ID = $1 AND provider_id = $2 ';
            await pool.query(deleteQuery, [Service_ID, provider_id]);

            res.status(200).json({
                status: "Success",
                message: "Service deleted successfully"
            });

        }
    } catch (error) {
        console.error("Error deleting account:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });



    }
}
const getallservices = async (req, res) => {
    const provider_id = req.ID;
    try {
        if (!provider_id) {
            return res.status(400).json({
                status: "Fail",
                message: "Some Error Haben"
            });
        }
        const Query = 'SELECT * FROM ServiceProvider WHERE Provider_Id = $1';
        const result = await pool.query(Query, [provider_id]);

        if (result.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "User doesn't exist."
            });
        }
        const getAllservices = await pool.query('SELECT * FROM Services WHERE Provider_ID=$1', [provider_id]);
        res.status(200).json({
            status: "Done",
            message: "One Data Is Here",
            data: getAllservices.rows
        });

    } catch (error) {
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }

}
const getService = async (req, res) => {

    const { Service_ID } = req.params;
    const provider_id = req.ID;
    try {

        if (!provider_id || !Service_ID) {
            return res.status(400).json({
                status: "Fail",
                message: "Some Error Haben"
            });
        }

        const Query = 'SELECT * FROM ServiceProvider WHERE Provider_Id = $1';
        const result = await pool.query(Query, [provider_id]);

        if (result.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "User doesn't exist."
            });
        }
        const getservices = await pool.query('SELECT * FROM Services WHERE Provider_ID=$1 AND Service_ID=$2', [provider_id, Service_ID]);
        res.status(200).json({
            status: "Done",
            message: "One Data Is Here",
            data: getservices.rows
        });

    } catch (error) {
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
}


// const Providerinfo = async (req, res) => {
//     const providerid = req.ID;
//     try {

//         if (!providerid) {
//             return res.status(400).json({
//                 status: "Fail",
//                 message: "Missing information"
//             });
//         }
//         const Query = 'SELECT * FROM ServiceProvider WHERE Provider_Id = $1';
//         const result = await pool.query(Query, [providerid]);

//         if (result.rows.length === 0) {
//             return res.status(401).json({
//                 status: "Fail",
//                 message: "User doesn't exist."
//             });
//         }
//         const getservices = await pool.query('SELECT * FROM Services WHERE Provider_ID=$1 ', [providerid]);
//         res.status(200).json({
//             status: "Done",
//             message: "One Data Is Here",
//             providerinfo: result.rows,
//             data: getservices.rows
//         });

//     } catch (error) {

//         res.status(500).json({
//             status: "Fail",
//             message: "Internal server error"
//         });

//     }

// }

const Providerinfo = async (req, res) => {
    const providerId = req.ID;

    try {
        if (!providerId) {
            return res.status(400).json({
                status: "Fail",
                message: "Please provide the provider ID"
            });
        }

        // Get provider information
        const providerQuery = `
            SELECT provider_id, username, phone, email, bio, date_of_birth, location, image 
            FROM ServiceProvider 
            WHERE Provider_Id = $1
        `;
        const providerResult = await pool.query(providerQuery, [providerId]);

        if (providerResult.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Provider not found"
            });
        }

        const providerinfo = providerResult.rows[0];

        // Calculate age of the provider
        const dob = new Date(providerinfo.date_of_birth);
        const ageDiffMs = Date.now() - dob.getTime();
        const ageDate = new Date(ageDiffMs); // milliseconds from epoch
        const age = Math.abs(ageDate.getUTCFullYear() - 1970);

        // Add age to the providerinfo object
        providerinfo.age = age;

        // Get provider services
        const servicesQuery = 'SELECT * FROM Services WHERE Provider_Id = $1';
        const servicesResult = await pool.query(servicesQuery, [providerId]);

        // Get provider rating and review count
        const ratingQuery = `
            SELECT 
                COALESCE(Rate_value, 0) AS provider_rating, 
                COALESCE(count, 0) AS review_count
            FROM Review r
            WHERE r.Provider_ID = $1
        `;
        const ratingResult = await pool.query(ratingQuery, [providerId]);

        const ratingData = ratingResult.rows[0] || { provider_rating: 0, review_count: 0 };


        // Add rating and review count to the providerinfo object
        providerinfo.rating = ratingData.provider_rating;
        providerinfo.reviewCount = ratingData.review_count;

        res.status(200).json({
            status: "Done",
            message: "One Data Is Here",
            providerinfo: [providerinfo],
            data: servicesResult.rows
        });

    } catch (error) {
        console.error("Error fetching provider info:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
};

const updateProviderLocation = async (req, res) => {
    const providerId = req.ID;
    console.log(providerId);
    const { lat, long } = req.body;
    console.log(lat, long);
    if (!lat || !long) {
        return res.status(400).json({
            status: "Fail",
            message: "Please provide both latitude and longitude"
        });
    }
    if (!providerId) {
        return res.status(400).json({
            status: "Fail",
            message: "Please provide the provider ID"
        });
    }

    try {
        const updateLocationQuery = `
            UPDATE ServiceProvider
            SET Location = POINT($1, $2)
            WHERE Provider_Id = $3
            RETURNING provider_id, username, phone, email, bio, date_of_birth, location, image
        `;
        const values = [lat, long, providerId];

        const result = await pool.query(updateLocationQuery, values);

        if (result.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Provider not found"
            });
        }

        res.status(200).json({
            status: "Success",
            message: "Location added successfully",
            providerinfo: result.rows[0]
        });
    } catch (error) {
        console.error("Error updating provider location:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
};



// const Providerinfo = async (req, res) => {
//     const providerId = req.ID;

//     try {
//         if (!providerId) {
//             return res.status(400).json({
//                 status: "Fail",
//                 message: "Missing information"
//             });
//         }

//         // Query to get provider information
//         const providerQuery = 'SELECT * FROM ServiceProvider WHERE Provider_Id = $1';
//         const providerResult = await pool.query(providerQuery, [providerId]);

//         if (providerResult.rows.length === 0) {
//             return res.status(401).json({
//                 status: "Fail",
//                 message: "User doesn't exist."
//             });
//         }

//         // Query to get provider services
//         const servicesQuery = 'SELECT * FROM Services WHERE Provider_ID = $1';
//         const servicesResult = await pool.query(servicesQuery, [providerId]);

//         // Query to get provider rating and review count
//         const ratingQuery = `
//             SELECT 
//                 COALESCE(AVG(r.Rate_value), 0) AS provider_rating, 
//                 COALESCE(COUNT(r.Rate_value), 0) AS review_count
//             FROM Review r
//             WHERE r.Provider_ID = $1
//         `;
//         const ratingResult = await pool.query(ratingQuery, [providerId]);

//         res.status(200).json({
//             status: "Done",
//             message: "One Data Is Here",
//             providerInfo: providerResult.rows[0],
//             services: servicesResult.rows,
//             rating: ratingResult.rows[0].provider_rating,
//             reviewCount: ratingResult.rows[0].review_count
//         });

//     } catch (error) {
//         console.error("Error:", error);
//         res.status(500).json({
//             status: "Fail",
//             message: "Internal server error"
//         });
//     }
// }



const getOwnerInfo = async (req, res) => {
    const provider_id = req.ID; // Assuming req.ID holds the provider's ID extracted from the token
    const owner_id = req.params.ownerId; // Assuming the owner ID is passed as a parameter in the request URL

    try {
        const providerQuery = 'SELECT * FROM ServiceProvider WHERE Provider_Id = $1';
        const providerResult = await pool.query(providerQuery, [provider_id]);

        if (providerResult.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "Provider doesn't exist."
            });
        }

        const ownerQuery = 'SELECT First_name,Last_name,Phone,Email,Date_of_birth,Location,Image FROM Petowner WHERE Owner_Id=$1';
        const ownerResult = await pool.query(ownerQuery, [owner_id]);

        if (ownerResult.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Owner not found."
            });
        }

        // Return the owner information
        res.status(200).json({
            status: "Success",
            data: ownerResult.rows[0] // Assuming there's only one owner with a matching ID
        });

    } catch (error) {
        console.error("Error fetching owner information:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
};

const changePassword = async (req, res) => {
    const providerId = req.ID;
    let { oldPassword, newPassword } = req.body;

    try {
        if (!providerId || !oldPassword || !newPassword) {
            return res.status(400).json({
                status: 'Fail',
                message: 'Please provide providerId, oldPassword, and newPassword.'
            });
        }

        const query = 'SELECT Password FROM ServiceProvider WHERE Provider_Id = $1';
        const result = await pool.query(query, [providerId]);

        if (result.rows.length === 0) {
            return res.status(404).json({
                status: 'Fail',
                message: 'Provider not found.'
            });
        }

        const currentPasswordHash = result.rows[0].password;

        // Compare the old password with the current password hash
        const isMatch = await bcrypt.compare(oldPassword, currentPasswordHash);
        if (!isMatch) {
            return res.status(400).json({
                status: 'Fail',
                message: 'Old password is incorrect.'
            });
        }

        // Hash the new password
        const newPasswordHash = await bcrypt.hash(newPassword, 10);

        // Update the password in the database
        const updateQuery = 'UPDATE ServiceProvider SET Password = $1 WHERE Provider_Id = $2';
        await pool.query(updateQuery, [newPasswordHash, providerId]);

        res.status(200).json({
            status: 'Success',
            message: 'Password changed successfully.'
        });

    } catch (e) {
        console.error("Error: ", e);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error."
        })

    }
}




module.exports = {
    signUp,
    signIn,
    deleteAccount,
    uploadphoto,
    resizePhoto,
    updateInfo,
    SelectServices,
    Killservice,
    getallservices,
    getService,
    forgotPassword,
    resetPassword,
    Providerinfo,
    getOwnerInfo,
    changePassword,
    validateAndTransfer,
    updateProviderLocation,



};