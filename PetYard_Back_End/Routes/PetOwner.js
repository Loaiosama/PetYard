const express = require('express');
const router = express.Router();
const PetOwnerController = require('../Controllers/OwnerAuthentication');
const  authMiddleware=require('./../Controllers/autMiddleware');

const PetProfileController = require('../Controllers/PetProfile');

router.post('/SignUp', PetOwnerController.signUp);
router.post('/SignIn', PetOwnerController.signIn);
router.delete('/deleteAcc',PetOwnerController.deleteAccount);

router.post('/addPet',authMiddleware, PetProfileController.AddPet);

router.get('/getAllPet',authMiddleware, PetProfileController.GetAllPet);

router.get('/getPet/:Pet_Id',authMiddleware, PetProfileController.GetPet);

router.delete('/RemoveAllPets',authMiddleware, PetProfileController.RemoveAllPet);

router.delete('/RemovePet/:Pet_Id',authMiddleware, PetProfileController.RemovePet);

router.put('/UpdatePet/:Pet_Id',authMiddleware, PetProfileController.updatePetProfile);


module.exports = router;
