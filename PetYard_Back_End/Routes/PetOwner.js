const express = require('express');
const router = express.Router();
const ReservationController = require('../Controllers/Reservation/ReservationController');
const MessageController = require('../Controllers/Messages/MessageController');
const ChatController=require('../Controllers/Chat/ChatController');
const PetOwnerController = require('../Controllers/Owner/OwnerAuthentication');
const  authMiddleware=require('../Controllers/Authentication/AuthMiddle');
const PetProfileController = require('../Controllers/Pet_Profile/PetProfileController');
const OrderController=require('../Controllers/Online_Store/OrderController');
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


router.post('/CreateChat/:Second_id',authMiddleware,ChatController.CreateChat);
router.get('/GetAllChat',authMiddleware,ChatController.FindUserChats);
router.get('/GetChat/:First_id/:Second_id',ChatController.FindChat);

router.post('/CreateMessage/:chat_id',authMiddleware,MessageController.CreateMessage);
router.get('/GetMessages/:chat_id',authMiddleware,MessageController.GetMessages);


router.post('/MakeOrder',authMiddleware,OrderController.MakeOrder);
router.get('/GetAllOrders',authMiddleware,OrderController.GetAllOrders);
router.get('/GetOrder/:order_id',authMiddleware,OrderController.GetOrder);
router.delete('/DeleteOrder/:order_id',authMiddleware,OrderController.DeleteOrder);

router.get('/SearchByname',authMiddleware,OrderController.SearchByname);
router.get('/SearchBycategory',authMiddleware,OrderController.SearchBycategory);
router.get('/SearchBybrand',authMiddleware,OrderController.SearchBybrand);


router.post('/AddOrderItem/:order_id/:product_id',authMiddleware,OrderController.AddOrderItem);
router.delete('/RemoveOrderItem/:order_id/:product_id/:order_item_id',authMiddleware,OrderController.RemoveOrderItem);
router.put('/UpdateOrderItem/:order_id/:product_id/:order_item_id',authMiddleware,OrderController.UpdateOrderItem);



router.get('/getproviders/:Type',authMiddleware,ReservationController.getproviders);




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
