const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const User = require('../../../models/user');
const { sequelize } = require('../../../database');
const sendMail = require('../../../services/sendMail');
const templateMail = require('../../../services/templateMail');
const generateStr = require('../../../services/randomStr');

module.exports = async (req, res, next) => {
  try {
    const emailUser = req.body.email;
    if (!emailUser) {
      const err = Error('Kamu belum memasukkan email');
      err.status = 400;
      throw err;
    }
    const passwordUser = req.body.password;
    if (!passwordUser) {
      const err = Error('Kamu belum memasukkan password');
      err.status = 400;
      throw err;
    }

    const generatedPassword = await new Promise((resolve, reject) => {
      bcrypt.genSalt(parseInt(process.env.SALT_ROUNDS, 10), (err, salt) => {
        if (err) reject(err);
        bcrypt.hash(passwordUser, salt, (error, hash) => {
          if (error) reject(error);
          else resolve(hash);
        });
      });
    });

    const createdUser = await sequelize.transaction(t => User.create({
      email: emailUser,
      password: generatedPassword,
    }, { transaction: t }));

    createdUser.password = '*********';

    const tokenGenerated = jwt.sign({
      exp: Math.floor(Date.now() / 1000) + (60 * 60),
      data: { email: emailUser, secureId: generateStr(3) },
      secureId: generateStr(),
    }, process.env.TOKEN_ACCOUNT_ACTIVATION);
    sendMail(
      emailUser,
      'Aktivasi akun',
      templateMail(
        `${process.env.URL_CLIENT}/account-activation?token=${tokenGenerated}&email=${emailUser}`,
        'Silahkan aktivasi akun kamu dengan klik tombol dibawah ini.',
      ),
    );

    res.status(200).json({
      msg: 'Yey, kamu berhasil register',
      user: createdUser,
    });
  } catch (err) {
    next(err);
  }
};
