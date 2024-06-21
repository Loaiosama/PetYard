const nodemailer = require('nodemailer');

const sendemail = async options=>{
    //1 create transporter

    const transporter =nodemailer.createTransport({
     service:"gmail",
     auth :{
        user: "pet.connect.team100@gmail.com",
        pass: "dsgb khnb xjft qojs"
     }//dsgb khnb xjft qojs

    });
    
    //2 define the email options 

    const mailOptions = {
        from :"PetYard Teams <hello@Teams.io>",
        to : options.email,
        subject :options.subject,
        text : options.message
    }


    transporter.sendMail(mailOptions, function(error, info){
        if (error) {
            console.log(error);
        } else {
            console.log('Email sent: ' + info.response);
        }
    });
    
}

module.exports={
    sendemail
}