const pool = require('../../db');
const passport = require('passport');
const GoogleStrategy = require('passport-google-oauth20').Strategy;


passport.use(new GoogleStrategy({
    clientID:  "930002154293-fdmgi83sdt74qe4lkf3aiml7bornvk5d.apps.googleusercontent.com",
    clientSecret: "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",
    callbackURL: "http://localhost:3000/PetOwner/callback"
  },
  function(accessToken, refreshToken, profile, done) 
  {
    

         console.log(profile);
        return done(null,profile);
  }
));

passport.serializeUser(function(user,done){
    done(null,user);
});

passport.deserializeUser(function(user,done){
    done(null,user);
});
