const nodemailer = require('nodemailer');

module.exports = async (toMail, subjectMail, htmlMail) => {
  const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
      user: process.env.GMAIL,
      pass: process.env.PASSWORD_GMAIL,
    },
  });

  const mailOptions = {
    from: 'Aksara Brawijaya Noreply',
    to: toMail,
    subject: subjectMail,
    html: htmlMail,
  };

  transporter.sendMail(mailOptions, (err, info) => {
    if (err) {
      // eslint-disable-next-line no-console
      console.log(`Reset password request: ${err.message}`);
    } else {
      // eslint-disable-next-line no-console
      console.log(`Reset password request: ${info.response}`);
    }
  });
};
