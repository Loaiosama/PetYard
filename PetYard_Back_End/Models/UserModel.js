const crypto=require('crypto');


const CreatePasswordResetToken=function(){

   const resetToken = crypto.randomBytes(32).toString('hex');

   
   const PasswordResetToken= crypto.createHash('sha256').update(resetToken).digest('hex');

   PasswordResetExpires=Date.now() +10*60*1000;
  
   return { resetToken, PasswordResetToken ,PasswordResetExpires};
}

module.exports={
    CreatePasswordResetToken
}