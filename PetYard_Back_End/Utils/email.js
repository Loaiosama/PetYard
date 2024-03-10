const nodemailer = require('nodemailer');

const sendemail = async options=>{
    //1 create transporter

    const transporter =nodemailer.createTransport({
     host : "sandbox.smtp.mailtrap.io",
     port :25,
     auth :{
        user: "0849db6708b184",
        pass: "5be14f013b1ff0"
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