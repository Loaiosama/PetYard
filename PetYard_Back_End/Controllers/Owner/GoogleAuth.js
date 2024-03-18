const pool = require('../../db');
const passport = require('passport');
const GoogleStrategy = require('passport-google-oauth20').Strategy;


passport.use(new GoogleStrategy({
    clientID:  "930002154293-fdmgi83sdt74qe4lkf3aiml7bornvk5d.apps.googleusercontent.com",
    clientSecret: "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",
    callbackURL: "http://localhost:3000/PetOwner/callback"
  },
  async function(accessToken, refreshToken, profile, done) {
    const firstname = profile._json.given_name;
    const lastname = profile._json.family_name;
    const email = profile._json.email;
    const image = profile._json.picture;

    const client = await pool.connect();
    try {
      const emailExistsQuery = 'SELECT * FROM Petowner WHERE Email = $1';
      const { rows } = await client.query(emailExistsQuery, [email]);

      if (rows.length === 1) {
        console.log("User already exists");
        return done(null, profile);
      } else {
        const insertQuery = 'INSERT INTO Petowner (First_name, Last_name, Password, Email, Phone, Date_of_birth, Image) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *';
        const insertResult = await client.query(insertQuery, [firstname, lastname, null, email, null, null, image]);
        console.log('User inserted:', insertResult.rows[0]);
        return done(null, profile);
      }
    } catch (error) {
      console.error('Error inserting or checking user:', error);
      return done(error);
    } finally {
      client.release(); 
    }
  }
));




passport.serializeUser(function(user,done){
    done(null,user);
});

passport.deserializeUser(function(user,done){
    done(null,user);
});
