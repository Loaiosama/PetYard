const passport = require('passport');
const GoogleStrategy = require('passport-google-oauth20').Strategy;


passport.use(new GoogleStrategy({
    clientID: "316747315466-snf2a4q9j2iaslf222fdqcn6ov20t3fr.apps.googleusercontent.com",
    clientSecret: "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",
    callbackURL: "http://localhost:3000/google/callback"
  },
  function(accessToken, refreshToken, profile, done) 
  {
    return done(null,profile);
  }
));

passport.serializeUser(function(user,done){
    done(null,user);
});

passport.deserializeUser(function(user,done){
    done(null,user);
});
