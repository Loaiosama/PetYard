const express = require('express');
const router = express.Router();
const ProviderController = require('../Controllers/Provider/ProviderAuth');
const authMiddleware = require('../Controllers/AuthMiddle');

router.post('/SignUp',ProviderController.uploadphoto,ProviderController.resizePhoto ,ProviderController.signUp);
router.post('/SignIn', ProviderController.signIn);
router.delete('/DeleteAcc',authMiddleware, ProviderController.deleteAccount);
router.put('/updateInfo',authMiddleware, ProviderController.updateInfo);


module.exports = router;