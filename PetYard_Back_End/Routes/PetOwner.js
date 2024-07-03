const express = require('express');
const router = express.Router();
const ReservationController = require('../Controllers/Reservation/BoardingController');
const PetOwnerController = require('../Controllers/Owner/OwnerAuthentication');
const authMiddleware = require('../Controllers/Authentication/AuthMiddle');
const PetProfileController = require('../Controllers/Pet_Profile/PetProfileController');
require('../Controllers/Owner/GoogleAuth');
require('../Controllers/Owner/Facebook');
const passport = require('passport');
const session = require('express-session');
const SittingController = require('../Controllers/Reservation/SittingController');
const GroomingController = require('../Controllers/Reservation/GroomingController');
// const ClinicController = require('../Controllers/Reservation/ClinicController');
const ReviewController = require('../Controllers/Review/ReviewController');
const geoFenceController = require('../Controllers/Location/geofenceController');
const WalkingController = require('../Controllers/Reservation/WalkingController')




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



//------------------------------ ROUTES FOR rating CONTROLLER ---------------------------------

router.post('/AddRating',authMiddleware,ReviewController.AddRating);
router.post('/AddComment/:review_id',authMiddleware,ReviewController.AddComment);
router.get('/recomendedProviders',authMiddleware,ReviewController.recomendedProviders);
router.get('/getAllReviews',authMiddleware,ReviewController.getAllReviews);
router.get('/GetAllReviewsForSpecificProvider/:providerid', authMiddleware, ReviewController.getAllReviewsForSpecificProvider);
router.get('/filterByRating/:minRating/:serviceType', authMiddleware, ReviewController.filterByRating);



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

// router.get('/getAllClinicProviders', authMiddleware, ClinicController.getAllClinicProviders);
// router.get('/getClinicSlotsForProvider/:provider_id', authMiddleware, ClinicController.getClinicSlotsForProvider);
// router.post('/bookClinicSlot', authMiddleware, ClinicController.bookClinicSlot);
// router.get('/getClinicReservations', authMiddleware, ClinicController.getClinicReservations);

// router.put('/updateClinicReservationToComplete/:Slot_ID',authMiddleware,ClinicController.updateClinicReservationtocomplete)


//------------------------------ ROUTES FOR Walking CONTROLLER ---------------------------------
router.post('/makeWalkingRequest', authMiddleware, WalkingController.makeWalkingRequest);
router.get('/GetPendingWalkingRequests', authMiddleware, WalkingController.GetPendingWalkingRequests);
router.get('/GetWalkingApplications/:Reserve_ID', authMiddleware, WalkingController.GetWalkingApplications);
router.put('/rejectWalkingApplication', authMiddleware, WalkingController.rejectApplication);
router.put('/acceptWalkingApplication', authMiddleware, WalkingController.acceptApplication);

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
