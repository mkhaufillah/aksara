const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const User = require('../../../models/user');
const generateStr = require('../../../services/randomStr');
const sendMail = require('../../../services/sendMail');
const templateMail = require('../../../services/templateMail');

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

    const users = await User.findAll({ where: { email: emailUser } });
    if (users.length <= 0) {
      const err = Error('Sayang sekali, email kamu belum terdaftar. Silahkan refresh halaman');
      err.status = 401;
      throw err;
    }

    if (!users[0].isActive) {
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
      const err = Error('Akun kamu belum terkonfirmasi, silahkan cek email kamu. Cek di inbox atau junk (spam) ya');
      err.status = 401;
      throw err;
    }

    await new Promise((resolve, reject) => {
      bcrypt.compare(passwordUser, users[0].password, (err, result) => {
        if (err) reject(err);
        if (!result) {
          const error = Error('Sayang sekali, password kamu tidak tepat, silahkan ulangi');
          error.status = 401;
          reject(error);
        } else resolve();
      });
    });

    users[0].password = '*********';

    const tokenGenerated = jwt.sign({
      exp: Math.floor(Date.now() / 1000) + (60 * 60 * 24 * 7),
      data: users[0],
      secureId: generateStr(),
    }, process.env.TOKEN_USER);

    res.status(200).json({
      msg: 'Yey, kamu berhasil login',
      token: tokenGenerated,
      user: users[0],
    });
  } catch (err) {
    next(err);
  }
};
