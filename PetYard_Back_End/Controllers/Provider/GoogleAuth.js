const pool = require('../../db');
const passport = require('passport');
const GoogleStrategy = require('passport-google-oauth20').Strategy;


passport.use(new GoogleStrategy({
    clientID:  "930002154293-fdmgi83sdt74qe4lkf3aiml7bornvk5d.apps.googleusercontent.com",
    clientSecret: "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",
    callbackURL: "http://localhost:3000/PetOwner/callback"
  },
  function(accessToken, refreshToken, profile, done) {
    const Firstname = profile._json.given_name;
    const Lastname = profile._json.family_name;
    const email = profile._json.email;
    const image = profile._json.picture;

    console.log(Firstname, Lastname, email, image);

    const insertQuery = 'INSERT INTO ServiceProvider (First_name, Last_name, Password, Email, Phone, Date_of_birth, Image) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *';

    pool.query(insertQuery, [Firstname, Lastname, null, email, null, null, image], (err, result) => {
      if (err) {
        console.error('Error inserting user:', err);
        return done(err);
      }
    
      console.log('User inserted:', result.rows[0]);
      return done(null, profile); 
    });
  }
));


passport.serializeUser(function(user,done){
    done(null,user);
});

passport.deserializeUser(function(user,done){
    done(null,user);
});
