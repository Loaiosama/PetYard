const stripe = require('stripe')('sk_test_51PTJooRs2c4dEAvUNiMETK8G8UrylXjjUX0hzy1kCbX8lBELXYfI2Uuyg9yEAtcgcUkd4uIpILhrjGUSxYgpWdBc00aONnihy4');

const checkout = async (req, res) => {
    try {
        const session = await stripe.checkout.sessions.create({
            payment_method_types: ['card'],
            line_items: [{
                price_data: {
                    currency: 'usd',
                    product_data: {
                        name: 'T-shirt',
                    },
                    unit_amount: 2000,
                },
                quantity: 1,
            }],
            mode: 'payment',
            success_url: 'http://localhost:3000/complete',
            cancel_url: 'http://localhost:3000/cancel',
        });

        res.status(200).json({
            status: "Success",
            sessionId: session.id
        });
    } catch (error) {
        console.error("Error creating Stripe session:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
};

module.exports = {
    checkout
};
