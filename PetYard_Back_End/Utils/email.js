const nodemailer = require('nodemailer');

const sendemail = async options => {
    //1 create transporter

    const transporter = nodemailer.createTransport({
        host: "smtp.gmail.com",
        port: 587,
        secure: false,
        auth: {
            user: "pet.connect.team100@gmail.com",
            pass: "vudc syhh dnhq uywj"
        },//dsgb khnb xjft qojs
        tls: {
            rejectUnauthorized: false
        }
        // password hamdy vudc syhh dnhq uywj
    });

    //2 define the email options 

    const mailOptions = {
        from: "PetYard Teams <hello@Teams.io>",
        to: options.email,
        subject: options.subject,
        text: options.message
    }


    transporter.sendMail(mailOptions, function (error, info) {
        if (error) {
            console.log(error);
        } else {
            console.log('Email sent: ' + info.response);
        }
    });

}

module.exports = {
    sendemail
}