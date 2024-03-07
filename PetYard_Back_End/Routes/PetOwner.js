const express = require('express');
const router = express.Router();
const PetOwnerController = require('../Controllers/OwnerAuthentication');
const  authMiddleware=require('./../Controllers/autMiddleware');
const PetProfileController = require('../Controllers/PetProfile');
require('./../Controllers/GoogleAuth');
const passport = require('passport');


router.post('/SignUp', PetOwnerController.signUp);
router.post('/SignIn', PetOwnerController.signIn);
router.delete('/deleteAcc',PetOwnerController.deleteAccount);

router.post('/addPet',authMiddleware, PetProfileController.AddPet);

router.get('/getAllPet',authMiddleware, PetProfileController.GetAllPet);

router.get('/getPet/:Pet_Id',authMiddleware, PetProfileController.GetPet);

router.delete('/RemoveAllPets',authMiddleware, PetProfileController.RemoveAllPet);

router.delete('/RemovePet/:Pet_Id',authMiddleware, PetProfileController.RemovePet);

router.put('/UpdatePet/:Pet_Id',authMiddleware, PetProfileController.updatePetProfile);

// Initialize passport middleware
router.use(passport.initialize());


router.get('/Auth/google',passport.authenticate('google',{scope: ['email' , 'profile']}));

router.get('/google/callback', passport.authenticate('google', {
    successRedirect: '/success', // Redirect to success page on successful authentication
    failureRedirect: '/failure'  // Redirect to failure page on authentication failure
  }));
  
// Define the success route
router.get('/success', (req, res) => {
    res.send('Authentication successful');
  });
  
  // Define the failure route
  router.get('/failure', (req, res) => {
    res.send('Authentication failed');
  });

module.exports = router;
