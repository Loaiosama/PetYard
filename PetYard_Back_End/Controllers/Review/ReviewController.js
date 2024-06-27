const { query } = require('express');
const pool = require('../../db');
const sendemail = require("./../../Utils/email");




const AddRating = async (req, res) => {
    const ownerid = req.ID;
    const { rate } = req.body;
    const { providerid } = req.params;
    
    try {
        if (!ownerid || !rate || !providerid) {
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

        const providerQuery = 'SELECT * FROM ServiceProvider WHERE Provider_Id = $1';
        const providerResult = await pool.query(providerQuery, [providerid]);

        if (providerResult.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "Provider doesn't exist."
            });
        }

        const reviewQuery = 'SELECT * FROM Review WHERE Provider_ID = $1';
        const reviewResult = await pool.query(reviewQuery, [providerid]);

        if (reviewResult.rows.length > 0) {
         
            const review = reviewResult.rows[0];
            const newCount = review.count + 1;
            const newRateValue = (review.rate_value + rate) / newCount;

            const updateQuery = 'UPDATE Review SET Rate_value = $1, count = $2 WHERE Provider_ID = $3';
            await pool.query(updateQuery, [newRateValue, newCount, providerid]);

            res.status(200).json({
                status: "Success",
                message: "Rating updated successfully."
            });
        } else {
            const insertQuery = 'INSERT INTO Review (Provider_ID, Rate_value, count) VALUES ($1, $2, $3)';
            await pool.query(insertQuery, [providerid, rate, 1]);

            res.status(201).json({
                status: "Success",
                message: "Rating added successfully."
            });
        }

            const message = `
            Dear ${providerResult.rows[0].username},

            Great news! You have received a new rating for your services.

            Here are the details:
            - Rating: ${rate}
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

const FilterByRating = async (req, res) => {
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
            SELECT sp.*, r.rate_value, r.count
            FROM ServiceProvider sp
            JOIN Review r ON sp.Provider_Id = r.Provider_ID
            WHERE r.rate_value >= $1
        `;
        const filterResult = await pool.query(filterQuery, [minRating]);

        if (filterResult.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "No providers found with the given rating."
            });
        }

        res.status(200).json({
            status: "Success",
            message: "Providers fetched successfully.",
            data: filterResult.rows
        });

    } catch (error) {
        console.error("Error:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error."
        });
    }
};

const SortByRating = async (req, res) => {
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
            SELECT sp.*, r.rate_value, r.count
            FROM ServiceProvider sp
            JOIN Review r ON sp.Provider_Id = r.Provider_ID
            ORDER BY r.rate_value DESC
        `;
        const sortResult = await pool.query(sortQuery);

        if (sortResult.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "No providers found."
            });
        }

        res.status(200).json({
            status: "Success",
            message: "Providers sorted by rating successfully.",
            data: sortResult.rows
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



module.exports={
    AddRating,
    FilterByRating,
    AddComment,
    SortByRating  
}