const express = require('express');
const router = express.Router();

const PetOwnerController = require('../Controllers/Owner/OwnerAuthentication');
const  authMiddleware=require('../Controllers/AuthMiddle');
const PetProfileController = require('../Controllers/PetProfile');
require('../Controllers/Owner/GoogleAuth');
require('../Controllers/Owner/Facebook');
const passport = require('passport');
const session = require('express-session');

router.post('/SignUp',PetOwnerController.uploadphoto,PetOwnerController.resizePhoto,PetOwnerController.signUp);

router.post('/SignIn', PetOwnerController.signIn);

router.delete('/DeleteAcc', authMiddleware, PetOwnerController.deleteAccount);

router.post('/AddPet',authMiddleware,PetProfileController.uploadpetphoto,PetProfileController.resizePhoto, PetProfileController.AddPet);

router.get('/getAllPet',authMiddleware, PetProfileController.GetAllPet);

router.get('/getPet/:Pet_Id',authMiddleware, PetProfileController.GetPet);

router.delete('/RemoveAllPets',authMiddleware, PetProfileController.RemoveAllPet);

router.delete('/RemovePet/:Pet_Id',authMiddleware, PetProfileController.RemovePet);

router.put('/UpdatePet/:Pet_Id',authMiddleware, PetProfileController.updatePetProfile);

router.post('/Forgotpassword', PetOwnerController.forgotPassword);

router.put('/Resetpassword/:token', PetOwnerController.resetPassword);

router.get('/ValidationCode/:ValidCode', PetOwnerController.validationCode);

router.put('/updateInfo',authMiddleware,PetOwnerController.uploadphoto,PetOwnerController.resizePhoto, PetOwnerController.updateInfo);


router.post('/authenticate',authMiddleware,PetOwnerController.startChat);

// Use express-session middleware
router.use(session({
  secret: 'X-h2tDeZTUMVBmVL', // Set your own secret key
  resave: false,
  saveUninitialized: false
}));

// Initialize passport middleware
router.use(passport.initialize());
router.use(passport.session());

router.get('/Auth/google',passport.authenticate('google',{scope: ['email' , 'profile']}));
router.get('/Auth/facebook',passport.authenticate('facebook', { scope: ['email'] }));


router.get('/callback', passport.authenticate('google', {
    successRedirect: '/PetOwner/success', // Redirect to success page on successful authentication
    failureRedirect: '/PetOwner/failure'  // Redirect to failure page on authentication failure
  }));


  router.get('/callback', passport.authenticate('facebook', {
    successRedirect: '/PetOwner/success', // Redirect to success page on successful authentication
    failureRedirect: '/PetOwner/failure'  // Redirect to failure page on authentication failure
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
