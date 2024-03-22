const express = require('express');
const router = express.Router();
const ProviderController = require('../Controllers/Provider/ProviderAuth');
const authMiddleware = require('../Controllers/AuthMiddle');
require('../Controllers/Provider/GoogleAuth');
const passport = require('passport');
const session = require('express-session');




router.post('/SignUp',ProviderController.uploadphoto,ProviderController.resizePhoto ,ProviderController.signUp);
router.post('/SignIn', ProviderController.signIn);
router.delete('/DeleteAcc',authMiddleware, ProviderController.deleteAccount);
router.put('/updateInfo',authMiddleware, ProviderController.uploadphoto,ProviderController.resizePhoto,ProviderController.updateInfo);
router.post('/SelectService',authMiddleware,ProviderController.SelectServices);
router.delete('/KillService/:Service_ID',authMiddleware,ProviderController.Killservice);

router.post('/authenticate',authMiddleware,ProviderController.startChat);

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
  
  router.get('/callback', passport.authenticate('google', {
      successRedirect: '/Provider/success', // Redirect to success page on successful authentication
      failureRedirect: '/Provider/failure'  // Redirect to failure page on authentication failure
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