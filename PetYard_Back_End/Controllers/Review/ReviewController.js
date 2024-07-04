const { query } = require('express');
const pool = require('../../db');
const sendemail = require("./../../Utils/email");




const AddRating = async (req, res) => {
    const ownerid = req.ID;
    const { rate, comment } = req.body;
    const providerid = req.query.providerid;

    try {
        if (!ownerid || rate === undefined || !providerid) {
            return res.status(400).json({
                status: "Fail",
                message: "Please fill all information."
            });
        }

        // Check if the owner exists
        const ownerQuery = 'SELECT * FROM Petowner WHERE Owner_Id = $1';
        const ownerResult = await pool.query(ownerQuery, [ownerid]);

        if (ownerResult.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "User doesn't exist."
            });
        }

        // Check if the provider exists
        const providerQuery = 'SELECT * FROM ServiceProvider WHERE Provider_Id = $1';
        const providerResult = await pool.query(providerQuery, [providerid]);

        if (providerResult.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "Provider doesn't exist."
            });
        }

        // Insert the individual review
        const insertReviewQuery = `
            INSERT INTO IndividualReviews (Provider_ID, Owner_ID, Rate_value, Comment)
            VALUES ($1, $2, $3, $4)
        `;
        await pool.query(insertReviewQuery, [providerid, ownerid, rate, comment]);

        // Update the review summary
        const reviewQuery = 'SELECT * FROM Review WHERE Provider_ID = $1';
        const reviewResult = await pool.query(reviewQuery, [providerid]);

        if (reviewResult.rows.length > 0) {
            const review = reviewResult.rows[0];
            const newCount = review.count + 1;
            const newRateValue = ((review.rate_value * review.count) + rate) / newCount;

            const updateQuery = 'UPDATE Review SET Rate_value = $1, count = $2 WHERE Provider_ID = $3';
            await pool.query(updateQuery, [newRateValue, newCount, providerid]);
        } else {
            const insertQuery = 'INSERT INTO Review (Provider_ID, Rate_value, count) VALUES ($1, $2, $3)';
            await pool.query(insertQuery, [providerid, rate, 1]);
        }

        res.status(201).json({
            status: "Success",
            message: "Rating added successfully."
        });

        // Send notification email to the provider
        const message = `
            Dear ${providerResult.rows[0].username},

            Great news! You have received a new rating for your services.

            Here are the details:
            - Rating: ${rate}
            - Comment: ${comment || "No comment"}
            - From: ${ownerResult.rows[0].first_name} ${ownerResult.rows[0].last_name}

            Your dedication to providing excellent service is greatly appreciated. Keep up the fantastic work!

            Best regards,
            The PetYard Team
        `;

        await sendemail.sendemail({
            email: providerResult.rows[0].email,
            subject: 'New Rating Received!',
            message
        });

    } catch (error) {
        console.error("Error:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error."
        });
    }
};

// const FilterByRating = async (req, res) => {
//     const ownerid = req.ID;
//     const { minRating } = req.params; 

//     try {
//         if (!minRating || !ownerid) {
//             return res.status(400).json({
//                 status: "Fail",
//                 message: "Please fill all information."
//             });
//         }

//         const ownerQuery = 'SELECT * FROM Petowner WHERE Owner_Id = $1';
//         const ownerResult = await pool.query(ownerQuery, [ownerid]);

//         if (ownerResult.rows.length === 0) {
//             return res.status(401).json({
//                 status: "Fail",
//                 message: "User doesn't exist."
//             });
//         }

//         const filterQuery = `
//             SELECT sp.Provider_Id, sp.UserName, sp.Phone, sp.Email, sp.Bio, sp.Date_of_birth, sp.Location, sp.Image, r.rate_value, r.count
//             FROM ServiceProvider sp
//             JOIN Review r ON sp.Provider_Id = r.Provider_ID
//             WHERE r.rate_value >= $1
//         `;
//         const filterResult = await pool.query(filterQuery, [minRating]);

//         if (filterResult.rows.length === 0) {
//             return res.status(404).json({
//                 status: "Fail",
//                 message: "No providers found with the given rating."
//             });
//         }

//         res.status(200).json({
//             status: "Success",
//             message: "Providers fetched successfully.",
//             data: filterResult.rows
//         });

//     } catch (error) {
//         console.error("Error:", error);
//         res.status(500).json({
//             status: "Fail",
//             message: "Internal server error."
//         });
//     }
// };


const filterByRating = async (req, res) => {
    const ownerid = req.ID;
    const { minRating, serviceType } = req.params;

    try {
        if (!minRating || !serviceType || !ownerid) {
            return res.status(400).json({
                status: "Fail",
                message: "Please fill all information."
            });
        }

        const ownerQuery = 'SELECT * FROM Petowner WHERE Owner_Id = $1';
        const ownerResult = await pool.query(ownerQuery, [ownerid]);

        if (ownerResult.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "User doesn't exist."
            });
        }

        const filterQuery = `
            SELECT sp.Provider_Id, sp.UserName, sp.Phone, sp.Email, sp.Bio, sp.Date_of_birth, sp.Location, sp.Image,
                   COALESCE(AVG(ir.Rate_value), 0) AS average_rating, COUNT(ir.Rate_value) AS review_count
            FROM ServiceProvider sp
            LEFT JOIN IndividualReviews ir ON sp.Provider_Id = ir.Provider_ID
            LEFT JOIN Services s ON sp.Provider_Id = s.Provider_Id
            WHERE s.Type = $2
            GROUP BY sp.Provider_Id
            HAVING COALESCE(AVG(ir.Rate_value), 0) >= $1
        `;
        const filterResult = await pool.query(filterQuery, [minRating, serviceType]);

        if (filterResult.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "No providers found with the given rating."
            });
        }

        // Fetch services for each provider
        const providersWithServices = await Promise.all(filterResult.rows.map(async (provider) => {
            const serviceQuery = 'SELECT * FROM Services WHERE Provider_Id = $1';
            const serviceResult = await pool.query(serviceQuery, [provider.provider_id]);
            return {
                ...provider,
                services: serviceResult.rows
            };
        }));

        res.status(200).json({
            status: "Success",
            message: "Providers sorted by rating successfully.",
            data: providersWithServices
        });

    } catch (error) {
        console.error("Error:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error."
        });
    }
};

const filterBoardingByRating = async (req, res) => {
    const ownerid = req.ID;
    const { minRating } = req.params;

    try {
        if (!minRating || !ownerid) {
            return res.status(400).json({
                status: "Fail",
                message: "Please fill all information."
            });
        }

        const ownerQuery = 'SELECT * FROM Petowner WHERE Owner_Id = $1';
        const ownerResult = await pool.query(ownerQuery, [ownerid]);

        if (ownerResult.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "User doesn't exist."
            });
        }

        const filterQuery = `
            SELECT sp.Provider_Id, sp.UserName, sp.Phone, sp.Email, sp.Bio, sp.Date_of_birth, sp.Location, sp.Image,
                   COALESCE(AVG(ir.Rate_value), 0) AS average_rating, COUNT(ir.Rate_value) AS review_count
            FROM ServiceProvider sp
            LEFT JOIN IndividualReviews ir ON sp.Provider_Id = ir.Provider_ID
            LEFT JOIN Services s ON sp.Provider_Id = s.Provider_Id
            WHERE s.Type = 'Boarding'
            GROUP BY sp.Provider_Id
            HAVING COALESCE(AVG(ir.Rate_value), 0) >= $1
        `;
        const filterResult = await pool.query(filterQuery, [minRating]);

        if (filterResult.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "No providers found with the given rating."
            });
        }

        // Fetch services for each provider
        const providersWithServices = await Promise.all(filterResult.rows.map(async (provider) => {
            const serviceQuery = 'SELECT * FROM Services WHERE Provider_Id = $1';
            const serviceResult = await pool.query(serviceQuery, [provider.provider_id]);
            return {
                ...provider,
                services: serviceResult.rows
            };
        }));

        res.status(200).json({
            status: "Success",
            message: "Providers sorted by rating successfully.",
            data: providersWithServices
        });

    } catch (error) {
        console.error("Error:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error."
        });
    }
};

const filterGroomingByRating = async (req, res) => {
    const ownerid = req.ID;
    const { minRating } = req.params;

    try {
        if (!minRating || !ownerid) {
            return res.status(400).json({
                status: "Fail",
                message: "Please fill all information."
            });
        }

        const ownerQuery = 'SELECT * FROM Petowner WHERE Owner_Id = $1';
        const ownerResult = await pool.query(ownerQuery, [ownerid]);

        if (ownerResult.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "User doesn't exist."
            });
        }

        const filterQuery = `
            SELECT sp.Provider_Id, sp.UserName, sp.Phone, sp.Email, sp.Bio, sp.Date_of_birth, sp.Location, sp.Image,
                   COALESCE(AVG(ir.Rate_value), 0) AS average_rating, COUNT(ir.Rate_value) AS review_count
            FROM ServiceProvider sp
            LEFT JOIN IndividualReviews ir ON sp.Provider_Id = ir.Provider_ID
            LEFT JOIN Services s ON sp.Provider_Id = s.Provider_Id
            WHERE s.Type = 'Grooming'
            GROUP BY sp.Provider_Id
            HAVING COALESCE(AVG(ir.Rate_value), 0) >= $1
        `;
        const filterResult = await pool.query(filterQuery, [minRating]);

        if (filterResult.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "No providers found with the given rating."
            });
        }

        // Fetch services for each provider
        const providersWithServices = await Promise.all(filterResult.rows.map(async (provider) => {
            const serviceQuery = 'SELECT * FROM Services WHERE Provider_Id = $1';
            const serviceResult = await pool.query(serviceQuery, [provider.provider_id]);
            return {
                ...provider,
                services: serviceResult.rows
            };
        }));

        res.status(200).json({
            status: "Success",
            message: "Providers sorted by rating successfully.",
            data: providersWithServices
        });

    } catch (error) {
        console.error("Error:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error."
        });
    }
};

const filterSittingByRating = async (req, res) => {
    const ownerid = req.ID;
    const { minRating } = req.params;

    try {
        if (!minRating || !ownerid) {
            return res.status(400).json({
                status: "Fail",
                message: "Please fill all information."
            });
        }

        const ownerQuery = 'SELECT * FROM Petowner WHERE Owner_Id = $1';
        const ownerResult = await pool.query(ownerQuery, [ownerid]);

        if (ownerResult.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "User doesn't exist."
            });
        }

        const filterQuery = `
            SELECT sp.Provider_Id, sp.UserName, sp.Phone, sp.Email, sp.Bio, sp.Date_of_birth, sp.Location, sp.Image,
                   COALESCE(AVG(ir.Rate_value), 0) AS average_rating, COUNT(ir.Rate_value) AS review_count
            FROM ServiceProvider sp
            LEFT JOIN IndividualReviews ir ON sp.Provider_Id = ir.Provider_ID
            LEFT JOIN Services s ON sp.Provider_Id = s.Provider_Id
            WHERE s.Type = 'Sitting'
            GROUP BY sp.Provider_Id
            HAVING COALESCE(AVG(ir.Rate_value), 0) >= $1
        `;
        const filterResult = await pool.query(filterQuery, [minRating]);

        if (filterResult.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "No providers found with the given rating."
            });
        }

        // Fetch services for each provider
        const providersWithServices = await Promise.all(filterResult.rows.map(async (provider) => {
            const serviceQuery = 'SELECT * FROM Services WHERE Provider_Id = $1';
            const serviceResult = await pool.query(serviceQuery, [provider.provider_id]);
            return {
                ...provider,
                services: serviceResult.rows
            };
        }));

        res.status(200).json({
            status: "Success",
            message: "Providers sorted by rating successfully.",
            data: providersWithServices
        });

    } catch (error) {
        console.error("Error:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error."
        });
    }
};

const filterWalkingByRating = async (req, res) => {
    const ownerid = req.ID;
    const { minRating } = req.params;

    try {
        if (!minRating || !ownerid) {
            return res.status(400).json({
                status: "Fail",
                message: "Please fill all information."
            });
        }

        const ownerQuery = 'SELECT * FROM Petowner WHERE Owner_Id = $1';
        const ownerResult = await pool.query(ownerQuery, [ownerid]);

        if (ownerResult.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "User doesn't exist."
            });
        }

        const filterQuery = `
            SELECT sp.Provider_Id, sp.UserName, sp.Phone, sp.Email, sp.Bio, sp.Date_of_birth, sp.Location, sp.Image,
                   COALESCE(AVG(ir.Rate_value), 0) AS average_rating, COUNT(ir.Rate_value) AS review_count
            FROM ServiceProvider sp
            LEFT JOIN IndividualReviews ir ON sp.Provider_Id = ir.Provider_ID
            LEFT JOIN Services s ON sp.Provider_Id = s.Provider_Id
            WHERE s.Type = 'Walking'
            GROUP BY sp.Provider_Id
            HAVING COALESCE(AVG(ir.Rate_value), 0) >= $1
        `;
        const filterResult = await pool.query(filterQuery, [minRating]);

        if (filterResult.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "No providers found with the given rating."
            });
        }

        // Fetch services for each provider
        const providersWithServices = await Promise.all(filterResult.rows.map(async (provider) => {
            const serviceQuery = 'SELECT * FROM Services WHERE Provider_Id = $1';
            const serviceResult = await pool.query(serviceQuery, [provider.provider_id]);
            return {
                ...provider,
                services: serviceResult.rows
            };
        }));

        res.status(200).json({
            status: "Success",
            message: "Providers sorted by rating successfully.",
            data: providersWithServices
        });

    } catch (error) {
        console.error("Error:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error."
        });
    }
};



// const SortByRating = async (req, res) => {
//     const ownerid = req.ID;

//     try {
//         if (!ownerid) {
//             return res.status(400).json({
//                 status: "Fail",
//                 message: "Owner ID is required."
//             });
//         }

//         const ownerQuery = 'SELECT * FROM Petowner WHERE Owner_Id = $1';
//         const ownerResult = await pool.query(ownerQuery, [ownerid]);

//         if (ownerResult.rows.length === 0) {
//             return res.status(401).json({
//                 status: "Fail",
//                 message: "User doesn't exist."
//             });
//         }

//         const sortQuery = `
//             SELECT sp.Provider_Id, sp.UserName, sp.Phone, sp.Email, sp.Bio, sp.Date_of_birth, sp.Location, sp.Image, r.rate_value, r.count
//             FROM ServiceProvider sp
//             JOIN Review r ON sp.Provider_Id = r.Provider_ID
//             ORDER BY r.rate_value DESC
//         `;
//         const sortResult = await pool.query(sortQuery);

//         if (sortResult.rows.length === 0) {
//             return res.status(404).json({
//                 status: "Fail",
//                 message: "No providers found."
//             });
//         }

//         res.status(200).json({
//             status: "Success",
//             message: "Providers sorted by rating successfully.",
//             data: sortResult.rows
//         });

//     } catch (error) {
//         console.error("Error:", error);
//         res.status(500).json({
//             status: "Fail",
//             message: "Internal server error."
//         });
//     }
// };

const recomendedProviders = async (req, res) => {
    const ownerid = req.ID;

    try {
        if (!ownerid) {
            return res.status(400).json({
                status: "Fail",
                message: "Owner ID is required."
            });
        }

        const ownerQuery = 'SELECT * FROM Petowner WHERE Owner_Id = $1';
        const ownerResult = await pool.query(ownerQuery, [ownerid]);

        if (ownerResult.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "User doesn't exist."
            });
        }

        const sortQuery = `
            SELECT sp.Provider_Id, sp.UserName, sp.Phone, sp.Email, sp.Bio, sp.Date_of_birth, sp.Location, sp.Image,
                   COALESCE(AVG(ir.Rate_value), 0) AS average_rating, COUNT(ir.Rate_value) AS review_count
            FROM ServiceProvider sp
            LEFT JOIN IndividualReviews ir ON sp.Provider_Id = ir.Provider_ID
            GROUP BY sp.Provider_Id
            ORDER BY average_rating DESC
        `;
        const sortResult = await pool.query(sortQuery);

        if (sortResult.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "No providers found."
            });
        }

        // Fetch services for each provider
        const providersWithServices = await Promise.all(sortResult.rows.map(async (provider) => {
            const serviceQuery = 'SELECT service_id, provider_id, type FROM Services WHERE Provider_Id = $1';
            const serviceResult = await pool.query(serviceQuery, [provider.provider_id]);
            return {
                ...provider,
                services: serviceResult.rows
            };
        }));

        res.status(200).json({
            status: "Success",
            message: "Providers sorted by rating successfully.",
            data: providersWithServices
        });

    } catch (error) {
        console.error("Error:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error."
        });
    }
};


const AddComment = async (req, res) => {
    const { review_id } = req.params;
    const { comment } = req.body;

    try {
        if (!review_id || !comment) {
            return res.status(400).json({
                status: "Fail",
                message: "Please provide review ID and comment."
            });
        }

        const reviewQuery = 'SELECT * FROM Review WHERE Review_ID = $1';
        const reviewResult = await pool.query(reviewQuery, [review_id]);

        if (reviewResult.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Review not found."
            });
        }

        const currentComments = reviewResult.rows[0].comments || [];
        currentComments.push(comment);

        const updateQuery = 'UPDATE Review SET comments = $1 WHERE Review_ID = $2';
        await pool.query(updateQuery, [currentComments, review_id]);

        res.status(200).json({
            status: "Success",
            message: "Comment added successfully."
        });

    } catch (error) {
        console.error("Error:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error."
        });
    }
};

const getAllReviews = async (req, res) => {
    try {
        const query = `
            SELECT r.Review_ID, r.Provider_ID, r.Rate_value, r.count, sp.username AS provider_username
            FROM Review r
            JOIN ServiceProvider sp ON r.Provider_ID = sp.Provider_Id
        `;
        const result = await pool.query(query);

        if (result.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "No reviews found."
            });
        }

        res.status(200).json({
            status: "Success",
            message: "Reviews fetched successfully.",
            data: result.rows
        });
    } catch (error) {
        console.error("Error:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error."
        });
    }
};
const getAllReviewsForSpecificProvider = async (req, res) => {
    const { providerid } = req.params;

    try {
        const query = `
            SELECT ir.Review_ID, ir.Provider_ID, ir.Rate_value, ir.Comment, ir.Created_At,
                   po.First_name || ' ' || po.Last_name AS owner_name, po.image As owner_image
            FROM IndividualReviews ir
            JOIN Petowner po ON ir.Owner_ID = po.Owner_Id
            WHERE ir.Provider_ID = $1
            ORDER BY ir.Created_At DESC
        `;
        const result = await pool.query(query, [providerid]);

        if (result.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "No reviews found for the specified provider."
            });
        }

        res.status(200).json({
            status: "Success",
            message: "Reviews fetched successfully.",
            data: result.rows
        });
    } catch (error) {
        console.error("Error:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error."
        });
    }
};

const getAllReviewsForMe = async (req, res) => {
    const providerid = req.ID;

    try {
        const query = `
            SELECT r.Review_ID, r.Provider_ID, r.Rate_value, r.count, r.comments, sp.username AS provider_username
            FROM Review r
            JOIN ServiceProvider sp ON r.Provider_ID = sp.Provider_Id
            WHERE r.Provider_ID = $1
        `;
        const result = await pool.query(query, [providerid]);

        if (result.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "No reviews found for the specified provider."
            });
        }

        res.status(200).json({
            status: "Success",
            message: "Reviews fetched successfully.",
            data: result.rows
        });
    } catch (error) {
        console.error("Error:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error."
        });
    }
};


module.exports = {
    AddRating,
    filterByRating,
    AddComment,
    recomendedProviders,
    getAllReviews,
    getAllReviewsForSpecificProvider,
    getAllReviewsForMe,

}