const express = require('express');
const router = express.Router();
const ProviderController = require('../Controllers/ProviderAuth');

router.post('/SignUp', ProviderController.signUp);

module.exports = router;