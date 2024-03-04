const express = require('express');
const router = express.Router();
const ProviderController = require('../Controllers/ProviderAuth');

router.post('/SignUp', ProviderController.signUp);
router.post('/SignIn', ProviderController.signIn);
router.delete('/deleteAcc', ProviderController.deleteAccount);


module.exports = router;