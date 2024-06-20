const express = require('express');
const path = require('path');
const morgan = require('morgan');
const app = express();

const PetOwnerRoutes = require('./routes/PetOwner');
const ProviderRoutes = require('./routes/Provider');

app.use(morgan('tiny'));
app.use(express.json());

// Set 'views' directory for any views
app.set('views', path.join(__dirname, 'views'));

// Set view engine to ejs
app.set('view engine', 'ejs');

// Routes
app.use('/PetOwner', PetOwnerRoutes);
app.use('/Provider', ProviderRoutes);

// Serve the checkout page
app.get('/checkout-page', (req, res) => {
    res.render('checkout');
});

module.exports = app;
