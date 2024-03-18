const pool = require('../../db');
const passport = require('passport');
const FacebookStrategy = require('passport-facebook').Strategy;


passport.use(new FacebookStrategy({
    clientID: "1629655827771291",
    clientSecret: "a619cd4ab247f14ebfe38d7ef17a36b0",
    callbackURL: "https://localhost:3000/PetOwner/callback"
  },
  function(accessToken, refreshToken, profile, done) {
    
      return done(null, profile);

  }
));


passport.serializeUser(function(user,done){
    done(null,user);
});

passport.deserializeUser(function(user,done){
    done(null,user);
});
