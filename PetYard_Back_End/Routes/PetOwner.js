const express = require('express');
const router = express.Router();
const PetOwnerController = require('../Controllers/OwnerAuthentication');

router.post('/SignUp', PetOwnerController.signUp);
router.post('/SignIn', PetOwnerController.signIn);
router.delete('/deleteAcc', PetOwnerController.deleteAccount);


module.exports = router;