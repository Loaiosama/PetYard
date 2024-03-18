const nodemailer = require('nodemailer');

const sendemail = async options=>{
    //1 create transporter

    const transporter =nodemailer.createTransport({
     service:"gmail",
     auth :{
        user: "pet.connect.team100@gmail.com",
        pass: "uuih xxyp crtl muem"
     }

    });
    
    //2 define the email options 

    const mailOptions = {
        from :"PetYard Teams <hello@Teams.io>",
        to : options.email,
        subject :options.subject,
        text : options.message
    }

    //3 Actually send the email 
    await transporter.sendMail(mailOptions);
    
}

module.exports={
    sendemail
}