const express = require('express');
const router = express.Router();
const ProviderController = require('../Controllers/Provider/ProviderAuth');
const authMiddleware = require('../Controllers/AuthMiddle');

router.post('/SignUp', ProviderController.signUp);
router.post('/SignIn', ProviderController.signIn);
router.delete('/DeleteAcc',authMiddleware, ProviderController.deleteAccount);


module.exports = router;