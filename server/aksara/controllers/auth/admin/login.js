const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const Admin = require('../../../models/admin');
const generateStr = require('../../../services/randomStr');

module.exports = async (req, res, next) => {
  try {
    const emailAdmin = req.body.email;
    if (!emailAdmin) {
      const err = Error('Kamu belum memasukkan email');
      err.status = 400;
      throw err;
    }
    const passwordAdmin = req.body.password;
    if (!passwordAdmin) {
      const err = Error('Kamu belum memasukkan password');
      err.status = 400;
      throw err;
    }

    const admins = await Admin.findAll({ where: { email: emailAdmin } });
    if (admins.length <= 0) {
      const err = Error('Sayang sekali, email kamu belum terdaftar');
      err.status = 401;
      throw err;
    }

    await new Promise((resolve, reject) => {
      bcrypt.compare(passwordAdmin, admins[0].password, (err, result) => {
        if (err) reject(err);
        if (!result) {
          const error = Error('Sayang sekali, password kamu tidak tepat, silahkan ulangi');
          error.status = 401;
          reject(error);
        } else resolve();
      });
    });

    admins[0].password = '*********';

    const tokenGenerated = jwt.sign({
      exp: Math.floor(Date.now() / 1000) + (60 * 60 * 24 * 7),
      data: admins[0],
      secureId: generateStr(),
    }, process.env.TOKEN_ADMIN);

    res.status(200).json({
      msg: 'Yey, kamu berhasil login',
      token: tokenGenerated,
      admin: admins[0],
    });
  } catch (err) {
    next(err);
  }
};
