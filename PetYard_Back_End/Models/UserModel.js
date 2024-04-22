const crypto=require('crypto');


const CreatePasswordResetToken=function(){

   const resetToken = crypto.randomBytes(32).toString('hex');

   
   const PasswordResetToken= crypto.createHash('sha256').update(resetToken).digest('hex');

      PasswordResetExpires= Date.now()+ 10*60*1000;
  
  
   return { resetToken, PasswordResetToken ,PasswordResetExpires};
}




const CreateValidationCode = function(){

    const characters = '0123456789';
    const length = 5; 
    let validationCode = '';
    for (let i = 0; i < length; i++) {
        validationCode += characters.charAt(Math.floor(Math.random() * characters.length));
    }

    VaildationcodeExpires=Date.now() +10*60*1000;

    return {validationCode,VaildationcodeExpires};
}







module.exports={
    CreatePasswordResetToken,
    CreateValidationCode,
   
}