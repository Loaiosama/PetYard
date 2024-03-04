const express = require('express');
const router = express.Router();
const PetOwnerController = require('../Controllers/OwnerAuthentication');
const  authMiddleware=require('./../Controllers/autMiddleware');

const PetProfileController = require('../Controllers/PetProfile');

router.post('/SignUp', PetOwnerController.signUp);
router.post('/SignIn', PetOwnerController.signIn);
router.delete('/deleteAcc',PetOwnerController.deleteAccount);

router.post('/addPet',authMiddleware, PetProfileController.AddPet);


module.exports = router;
