const express = require('express');
const router = express.Router();
const ReservationController = require('../Controllers/Reservation/BoardingController');
const publisher = require('../Controllers/Messages/publisher');
const subscriber = require('../Controllers/Messages/subscriber');
const SocialMedia = require('../Controllers/Community/SocialMedia');
const ChatController = require('../Controllers/Chat/ChatController');
const PetOwnerController = require('../Controllers/Owner/OwnerAuthentication');
const authMiddleware = require('../Controllers/Authentication/AuthMiddle');
const PetProfileController = require('../Controllers/Pet_Profile/PetProfileController');
const OrderController = require('../Controllers/Online_Store/OrderController');
require('../Controllers/Owner/GoogleAuth');
require('../Controllers/Owner/Facebook');
const passport = require('passport');
const session = require('express-session');
const payment = require('../Controllers/Payment/payment');
const Shipping = require('../Controllers/Shipping/ShippingController')
const SittingController = require('../Controllers/Reservation/SittingController');
const GroomingController = require('../Controllers/Reservation/GroomingController');
const ClinicController = require('../Controllers/Reservation/ClinicController');
const ReviewController = require('../Controllers/Review/ReviewController');
const geoFenceController = require('../Controllers/Location/geofenceController');




router.get('/Getinfo', authMiddleware, PetOwnerController.getinfo);
router.post('/SignUp', PetOwnerController.uploadphoto, PetOwnerController.resizePhoto, PetOwnerController.signUp);
router.post('/SignIn', PetOwnerController.signIn);
router.delete('/DeleteAcc', authMiddleware, PetOwnerController.deleteAccount);

router.post('/AddPet', authMiddleware, PetProfileController.uploadpetphoto, PetProfileController.resizePhoto, PetProfileController.AddPet);
router.get('/getAllPet', authMiddleware, PetProfileController.GetAllPet);
router.get('/getPet/:Pet_Id', authMiddleware, PetProfileController.GetPet);
router.delete('/RemoveAllPets', authMiddleware, PetProfileController.RemoveAllPet);
router.delete('/RemovePet/:Pet_Id', authMiddleware, PetProfileController.RemovePet);
router.put('/UpdatePet/:Pet_Id', authMiddleware, PetProfileController.uploadpetphoto, PetProfileController.resizePhoto, PetProfileController.updatePetProfile);

router.post('/Forgotpassword', PetOwnerController.forgotPassword);
router.put('/Resetpassword/:token', PetOwnerController.resetPassword);
router.get('/ValidationCode/:ValidCode', PetOwnerController.validationCode);
router.put('/updateInfo', authMiddleware, PetOwnerController.uploadphoto, PetOwnerController.resizePhoto, PetOwnerController.updateInfo);



router.post('/CreateChat/:Second_id', authMiddleware, ChatController.CreateChat);
router.get('/GetAllChat', authMiddleware, ChatController.FindUserChats);
router.get('/GetChat/:First_id/:Second_id', ChatController.FindChat);


router.post('/CreateMessage/:Chat_ID', authMiddleware, publisher.publish);
router.post('/GetMessages/:Chat_ID', authMiddleware, subscriber.subscribe);


router.post('/MakeOrder', authMiddleware, OrderController.MakeOrder);
router.get('/GetAllOrders', authMiddleware, OrderController.GetAllOrders);
router.get('/GetOrder/:order_id', authMiddleware, OrderController.GetOrder);
router.delete('/DeleteOrder/:order_id', authMiddleware, OrderController.DeleteOrder);

router.get('/SearchByname', authMiddleware, OrderController.SearchByname);
router.get('/SearchBycategory', authMiddleware, OrderController.SearchBycategory);
router.get('/SearchBybrand', authMiddleware, OrderController.SearchBybrand);


router.post('/AddOrderItem/:order_id/:product_id', authMiddleware, OrderController.AddOrderItem);
router.delete('/RemoveOrderItem/:order_id/:product_id/:order_item_id', authMiddleware, OrderController.RemoveOrderItem);
router.put('/UpdateOrderItem/:order_id/:product_id/:order_item_id', authMiddleware, OrderController.UpdateOrderItem);





router.get('/GetProvidersByType/:type', authMiddleware, ReservationController.getProvidersByType);
router.get('/GetSlotProvider/:Provider_id/:Service_id', authMiddleware, ReservationController.GetSlotProvider);
router.get('/GetProviderInfo/:Provider_id', authMiddleware, ReservationController.getProviderInfo);
router.post('/ReserveSlot', authMiddleware, ReservationController.ReserveSlot);
router.get('/GetOwnerReservations', authMiddleware, ReservationController.GetOwnerReservations);


router.get('/GetAllAcceptedandfinishedReservations', authMiddleware, ReservationController.GetAllAccepted);
router.put('/updateCompletedReservations/:reserve_id', authMiddleware, ReservationController.updateCompletedReservations);
router.get('/GetALLCompleted', authMiddleware, ReservationController.GetALLCompleted);
router.get('/GetAllPending', authMiddleware, ReservationController.GetAllPending);
router.get('/GetAllRejected', authMiddleware, ReservationController.GetAllRejected);


router.post('/FeesDisplay', authMiddleware, ReservationController.FeesDisplay);




router.post('/FollowUsers/:user_id', authMiddleware, SocialMedia.FollowUser);
router.get('/SearchByName/:name', authMiddleware, SocialMedia.SearchUsersByName);
router.delete('/UnfollowUsers/:user_id', authMiddleware, SocialMedia.UnfollowUsers);
router.post('/Createpost', authMiddleware, SocialMedia.uploadphoto, SocialMedia.resizePhoto, SocialMedia.CreatePosts);
router.put('/Updatepost/:post_id', authMiddleware, SocialMedia.uploadphoto, SocialMedia.resizePhoto, SocialMedia.updatePost);
router.delete('/DeletePost/:post_id', authMiddleware, SocialMedia.DeletePost);
router.put('/LikeOrDislikePost/:post_id', authMiddleware, SocialMedia.LikeOrDislikePost);
router.get('/GetPost/:post_id', authMiddleware, SocialMedia.getpost);
router.get('/GetTimelinePost', authMiddleware, SocialMedia.getTimelinePosts);


router.get('/checkout', payment.checkout);

//------------------------------ ROUTES FOR rating CONTROLLER ---------------------------------

router.post('/AddRating',authMiddleware,ReviewController.AddRating);
router.post('/AddComment/:review_id',authMiddleware,ReviewController.AddComment);
router.get('/recomendedProviders',authMiddleware,ReviewController.recomendedProviders);
router.get('/getAllReviews',authMiddleware,ReviewController.getAllReviews);
router.get('/GetAllReviewsForSpecificProvider/:providerid', authMiddleware, ReviewController.getAllReviewsForSpecificProvider);
router.get('/filterByRating/:minRating/:serviceType', authMiddleware, ReviewController.filterByRating);


router.post('/AddShipping/:order_id', authMiddleware, Shipping.AddShipping);
router.put('/UpdateStatus/:Shipping_id', authMiddleware, Shipping.updateStatus);

//------------------------------ ROUTES FOR SITTING CONTROLLER ---------------------------------
router.post('/makeSittingRequest', authMiddleware, SittingController.makeRequest);
router.get('/getSittingRequests', authMiddleware, SittingController.GetSittingReservations);
router.get('/getSittingApplications/:Reserve_ID', authMiddleware, SittingController.getSittingApplications);
router.put('/acceptSittingApplication', authMiddleware, SittingController.acceptSittingApplication);
router.put('/rejectApplication', authMiddleware, SittingController.rejectApplication);


//------------------------------ ROUTES FOR GROOMING CONTROLLER ---------------------------------
router.get('/getPendingGroomingSlotsForProvider/:provider_id',authMiddleware,GroomingController.getPendingGroomingSlotsForProvider);
router.post('/bookGroomingSlot', authMiddleware, GroomingController.bookGroomingSlot);
router.get('/getGroomingReservations', authMiddleware, GroomingController.getGroomingReservations);
router.put('/updateGroomingReservationToComplete/:Slot_ID',authMiddleware,GroomingController.updateGroomingReservationtocomplete)
router.get('/getAllGroomingProviders', authMiddleware,GroomingController.getAllGroomingProviders);
router.post('/getFees', authMiddleware, GroomingController.getFees);
router.get('/getGroomingTypes/:providerId',authMiddleware,GroomingController.getGroomingTypesForProvidertoowner);

//------------------------------ ROUTES FOR clinic CONTROLLER ---------------------------------

router.get('/getAllClinicProviders', authMiddleware, ClinicController.getAllClinicProviders);
router.get('/getClinicSlotsForProvider/:provider_id', authMiddleware, ClinicController.getClinicSlotsForProvider);
router.post('/bookClinicSlot', authMiddleware, ClinicController.bookClinicSlot);
router.get('/getClinicReservations', authMiddleware, ClinicController.getClinicReservations);

router.put('/updateClinicReservationToComplete/:Slot_ID',authMiddleware,ClinicController.updateClinicReservationtocomplete)



//------------------------------ ROUTES FOR Location CONTROLLER ---------------------------------
router.post('/setGeoLocation', authMiddleware, geoFenceController.setGeofence);




// Use express-session middleware
router.use(session({
  secret: 'X-h2tDeZTUMVBmVL', // Set your own secret key
  resave: false,
  saveUninitialized: false
}));

// Initialize passport middleware
router.use(passport.initialize());
router.use(passport.session());

router.get('/Auth/google', passport.authenticate('google', { scope: ['email', 'profile'] }));
router.get('/Auth/facebook', passport.authenticate('facebook', { scope: ['email'] }));


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
