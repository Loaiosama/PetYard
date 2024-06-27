const express = require('express');
const router = express.Router();
const publisher = require('../Controllers/Messages/publisher');
const subscriber = require('../Controllers/Messages/subscriber');
const SocialMedia = require('../Controllers/Community/SocialMedia');
const ChatController=require('../Controllers/Chat/ChatController');
const ProviderController = require('../Controllers/Provider/ProviderAuth');
const authMiddleware = require('../Controllers/Authentication/AuthMiddle');
const StoreController=require('../Controllers/Online_Store/StoreController');
const ScheduleController=require('../Controllers/Schedule/ScheduleController');
const ReservationController = require('../Controllers/Reservation/BoardingController');
require('../Controllers/Provider/GoogleAuth');
const passport = require('passport');
const session = require('express-session');
const Shipping=require('../Controllers/Shipping/ShippingController');
const SittingController = require('../Controllers/Reservation/SittingController');
const GroomingController = require('../Controllers/Reservation/GroomingController');
const ClinicController = require('../Controllers/Reservation/ClinicController');





router.post('/SignUp',ProviderController.uploadphoto,ProviderController.resizePhoto ,ProviderController.signUp);
router.post('/SignIn', ProviderController.signIn);
router.delete('/DeleteAcc',authMiddleware, ProviderController.deleteAccount);
router.put('/updateInfo',authMiddleware, ProviderController.uploadphoto,ProviderController.resizePhoto,ProviderController.updateInfo);
router.post('/Forgotpassword', ProviderController.forgotPassword);
router.put('/Resetpassword/:token', ProviderController.resetPassword);

router.post('/SelectService',authMiddleware,ProviderController.SelectServices);
router.delete('/KillService/:Service_ID',authMiddleware,ProviderController.Killservice);
router.get('/GetAllServices',authMiddleware,ProviderController.getallservices);
router.get('/GetService/:Service_ID',authMiddleware,ProviderController.getService);

router.get('/GetProviderInfo',authMiddleware,ProviderController.Providerinfo);


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

router.post('/CreateMessage/:Chat_ID',authMiddleware,publisher.publish);
router.post('/GetMessages/:Chat_ID',authMiddleware,subscriber.subscribe);



router.get('/GetProviderReservations',authMiddleware,ReservationController.GetProviderReservations);
router.put('/UpdateReservation/:reserve_id',authMiddleware,ReservationController.UpdateReservation);

router.post('/authenticate',authMiddleware,ProviderController.startChat);



router.post('/FollowUsers/:user_id',authMiddleware,SocialMedia.FollowUser);
router.get('/SearchByName/:name',authMiddleware,SocialMedia.SearchUsersByName);
router.delete('/UnfollowUsers/:user_id',authMiddleware,SocialMedia.UnfollowUsers);
router.post('/Createpost',authMiddleware,SocialMedia.uploadphoto,SocialMedia.resizePhoto,SocialMedia.CreatePosts);
router.put('/updatePost/:post_id',authMiddleware,SocialMedia.uploadphoto,SocialMedia.resizePhoto,SocialMedia.updatePost);
router.delete('/DeletePost/:post_id',authMiddleware,SocialMedia.DeletePost);
router.put('/LikeOrDislikePost/:post_id', authMiddleware, SocialMedia.LikeOrDislikePost);
router.get('/GetPost/:post_id',authMiddleware,SocialMedia.getpost);
router.get('/GetTimelinePost',authMiddleware,SocialMedia.getTimelinePosts);




router.delete('/RemoveShipping/:Shipping_id',authMiddleware,Shipping.RemoveShipping);
router.get('/ReceivedShipping/:Shipping_id',authMiddleware,Shipping.received);



//------------------------------ ROUTES FOR SITTING CONTROLLER ---------------------------------
router.post('/applySittingRequest', authMiddleware, SittingController.applySittingRequest);
router.get('/GetAllSittingRequset',authMiddleware,SittingController.GetAllRequset);
router.get('/getAllSittingPendingRequests', authMiddleware, SittingController.getAllPendingRequests);


//------------------------------ ROUTES FOR GROOMING CONTROLLER ---------------------------------
router.post('/createGroomingSlots', authMiddleware, GroomingController.createGroomingSlots);
router.post('/setGroomingTypes', authMiddleware, GroomingController.setGroomingTypesForProvider);
router.put('/updateGroomingTypes/:oldgroomingTypeid',authMiddleware,GroomingController.updateGroomingTypesForProvider);
router.delete('/deleteGroomingTypes/:groomingTypeId',authMiddleware,GroomingController.DeleteGroomingTypesForProvider);
router.get('/getGroomingTypes', authMiddleware, GroomingController.getGroomingTypesForProvider);
router.get('/getGroomingSlots', authMiddleware, GroomingController.getGroomingSlots);

//------------------------------ ROUTES FOR clinic CONTROLLER ---------------------------------
router.post('/createClinicSlots', authMiddleware, ClinicController.createClinicSlots);
router.post('/setClinicTypes', authMiddleware, ClinicController.setClinicTypesForProvider);
router.get('/getClinicTypes', authMiddleware, ClinicController.getClinicTypesForProvider);
router.put('/updateClinicTypes/:oldclinicTypeid',authMiddleware,ClinicController.updateClinicTypesForProvider);
router.delete('/deleteClinicTypes/:clinicTypeId',authMiddleware,ClinicController.DeleteClinicTypesForProvider);
router.get('/getClinicSlots', authMiddleware, ClinicController.getClinicSlots);








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