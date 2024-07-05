const express = require('express');
const router = express.Router();
const ProviderController = require('../Controllers/Provider/ProviderAuth');
const authMiddleware = require('../Controllers/Authentication/AuthMiddle');
const ScheduleController=require('../Controllers/Schedule/ScheduleController');
const ReservationController = require('../Controllers/Reservation/BoardingController');
require('../Controllers/Provider/GoogleAuth');
const passport = require('passport');
const session = require('express-session');
const SittingController = require('../Controllers/Reservation/SittingController');
const GroomingController = require('../Controllers/Reservation/GroomingController');
// const ClinicController = require('../Controllers/Reservation/ClinicController');
const ReviewController = require('../Controllers/Review/ReviewController');
const PetProfileController=require('../Controllers/Pet_Profile/PetProfileController');
const WalkingController = require('../Controllers/Reservation/WalkingController');






router.post('/SignUp',ProviderController.uploadphoto,ProviderController.resizePhoto ,ProviderController.signUp);
router.post('/SignIn', ProviderController.signIn);
router.delete('/DeleteAcc',authMiddleware, ProviderController.deleteAccount);
router.put('/updateInfo',authMiddleware, ProviderController.uploadphoto,ProviderController.resizePhoto,ProviderController.updateInfo);
router.post('/Forgotpassword', ProviderController.forgotPassword);
router.put('/Resetpassword/:token', ProviderController.resetPassword);
// change password
router.put('/changePassword', authMiddleware, ProviderController.changePassword);
router.post('/validateCode', ProviderController.validateAndTransfer);





router.post('/SelectService',authMiddleware,ProviderController.SelectServices);
router.delete('/KillService/:Service_ID',authMiddleware,ProviderController.Killservice);
router.get('/GetAllServices',authMiddleware,ProviderController.getallservices);
router.get('/GetService/:Service_ID',authMiddleware,ProviderController.getService);

router.get('/GetProviderInfo',authMiddleware,ProviderController.Providerinfo);
router.get('/GetOwnerInfo/:ownerId',authMiddleware,ProviderController.getOwnerInfo);


router.post('/CreateSlot/:Service_ID',authMiddleware,ScheduleController.CreateSlot);
router.get('/GetAllSlots',authMiddleware,ScheduleController.GetAllSlots);
router.get('/GetSlot/:Slot_ID',authMiddleware,ScheduleController.GetSlot);
router.delete('/DeleteSlot/:Slot_ID',authMiddleware,ScheduleController.DeleteSlot);
router.put('/UpdateSlot/:Slot_ID',authMiddleware,ScheduleController.UpdateSlot);



router.get('/GetProviderReservations',authMiddleware,ReservationController.GetProviderReservations);
router.put('/UpdateReservation/:reserve_id',authMiddleware,ReservationController.UpdateReservation);



router.get('/GetPetForProvider/:Pet_Id',authMiddleware,PetProfileController.GetPetForProvider);

router.get('/UpcomingRequests',authMiddleware,ReservationController.UpcomingRequests);
router.get('/GetAllAccepted', authMiddleware, ReservationController.GetALLAcceptedReservation);
router.get('/GetAllPending', authMiddleware, ReservationController.GetALLPendingReservation);

router.get('/GetAllRejected', authMiddleware, ReservationController.GetALLRejectedReservation);
router.get('/GetALLCompleted', authMiddleware, ReservationController.GetALLCompletedReservation);

//------------------------------ ROUTES FOR SITTING CONTROLLER ---------------------------------
router.post('/applySittingRequest', authMiddleware, SittingController.applySittingRequest);
router.get('/GetAllSittingRequset',authMiddleware,SittingController.GetAllRequset);
router.get('/getAllSittingPendingRequests', authMiddleware, SittingController.getAllPendingRequests);


//-----------------------------------------------reviews--------------------------------------------
router.get('/getAllReviewsForMe',authMiddleware,ReviewController.getAllReviewsForMe);



//------------------------------ ROUTES FOR GROOMING CONTROLLER ---------------------------------
router.post('/createGroomingSlots', authMiddleware, GroomingController.createGroomingSlots);
router.post('/setGroomingTypes', authMiddleware, GroomingController.setGroomingTypesForProvider);
router.put('/updateGroomingTypes/:oldgroomingTypeid',authMiddleware,GroomingController.updateGroomingTypesForProvider);
router.delete('/deleteGroomingTypes/:groomingTypeId',authMiddleware,GroomingController.DeleteGroomingTypesForProvider);
router.get('/getGroomingTypes', authMiddleware, GroomingController.getGroomingTypesForProvider);
router.get('/getGroomingSlots', authMiddleware, GroomingController.getGroomingSlots);
router.put('/updatePriceForService', authMiddleware, GroomingController.updatePriceOfService);
router.get('/getGroomingReservation', authMiddleware, GroomingController.getGroomingReservationsForProvider);


//------------------------------ ROUTES FOR clinic CONTROLLER ---------------------------------
// router.post('/createClinicSlots', authMiddleware, ClinicController.createClinicSlots);
// router.post('/setClinicTypes', authMiddleware, ClinicController.setClinicTypesForProvider);
// router.get('/getClinicTypes', authMiddleware, ClinicController.getClinicTypesForProvider);
// router.put('/updateClinicTypes/:oldclinicTypeid',authMiddleware,ClinicController.updateClinicTypesForProvider);
// router.delete('/deleteClinicTypes/:clinicTypeId',authMiddleware,ClinicController.DeleteClinicTypesForProvider);
// router.get('/getClinicSlots', authMiddleware, ClinicController.getClinicSlots);


//------------------------------ ROUTES FOR Walking CONTROLLER ---------------------------------
router.post('/applyForWalkingRequest', authMiddleware, WalkingController.applyForWalkingRequest);
router.get('/getAllPendingRequests', authMiddleware, WalkingController.getAllPendingRequests);
// router.get('/getAllRequest',authMiddleware,WalkingController.GetAllRequset);
router.get('/getALLAcceptedRequest',authMiddleware,WalkingController.getALLAcceptedRequest);
router.get('/UpcomingRequestsForWalking',authMiddleware,WalkingController.UpcomingRequests);
router.put('/startWalk', authMiddleware, WalkingController.startWalk);





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