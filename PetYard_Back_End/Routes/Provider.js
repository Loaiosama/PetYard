const express = require('express');
const router = express.Router();
const MessageController = require('../Controllers/Messages/MessageController');
const ChatController=require('../Controllers/Chat/ChatController');
const ProviderController = require('../Controllers/Provider/ProviderAuth');
const authMiddleware = require('../Controllers/Authentication/AuthMiddle');
const StoreController=require('../Controllers/Online_Store/StoreController');
const ScheduleController=require('../Controllers/Schedule/ScheduleController');
const ReservationController = require('../Controllers/Reservation/ReservationController');
require('../Controllers/Provider/GoogleAuth');
const passport = require('passport');
const session = require('express-session');




router.post('/SignUp',ProviderController.uploadphoto,ProviderController.resizePhoto ,ProviderController.signUp);
router.post('/SignIn', ProviderController.signIn);
router.delete('/DeleteAcc',authMiddleware, ProviderController.deleteAccount);
router.put('/updateInfo',authMiddleware, ProviderController.uploadphoto,ProviderController.resizePhoto,ProviderController.updateInfo);


router.post('/SelectService',authMiddleware,ProviderController.SelectServices);
router.delete('/KillService/:Service_ID',authMiddleware,ProviderController.Killservice);
router.get('/GetAllServices',authMiddleware,ProviderController.getallservices);
router.get('/GetService/:Service_ID',authMiddleware,ProviderController.getService);


router.post('/CreateSlot/:Service_ID',authMiddleware,ScheduleController.CreateSlot);
router.get('/GetAllSlots',authMiddleware,ScheduleController.GetAllSlots);
router.get('/GetSlot/:Slot_ID',authMiddleware,ScheduleController.GetSlot);
router.delete('/DeleteSlot/:Slot_ID',authMiddleware,ScheduleController.DeleteSlot);
router.put('/UpdateSlot/:Slot_ID',authMiddleware,ScheduleController.UpdateSlot);


router.post('/AddProduct',authMiddleware,StoreController.uploadphoto,StoreController.resizePhotoProduct,StoreController.Add_Product);
router.get('/GetAllProduct',authMiddleware,StoreController.GetAllProduct);
router.get('/GetProduct/:Product_Id',authMiddleware,StoreController.GetProduct);
router.put('/UpdateProduct/:Product_Id',authMiddleware,StoreController.uploadphoto,StoreController.resizePhotoProduct,StoreController.UpdateProduct);
router.delete('/RemoveProduct/:Product_Id',authMiddleware,StoreController.RemoveProduct);




router.get('/GetAllChat',authMiddleware,ChatController.FindUserChats);
router.get('/GetChat/:First_id/:Second_id',ChatController.FindChat);

router.post('/CreateMessage/:chat_id',authMiddleware,MessageController.CreateMessage);
router.get('/GetMessages/:chat_id',authMiddleware,MessageController.GetMessages);
//router.post('/SendMessage/:chat_id',MessageController.SendMessage);




router.get('/GetProviderReservations',authMiddleware,ReservationController.GetProviderReservations);
router.put('/UpdateReservation/:reserve_id',authMiddleware,ReservationController.UpdateReservation);

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