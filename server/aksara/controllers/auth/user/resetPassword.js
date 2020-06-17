const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const User = require('../../../models/user');
const generateStr = require('../../../services/randomStr');
const sendMail = require('../../../services/sendMail');
const templateMail = require('../../../services/templateMail');
const { Sequelize } = require('../../../database');

const request = async (req, res, next) => {
  try {
    const emailUser = req.body.email;
    if (!emailUser) {
      const err = Error('Kamu belum memasukkan email');
      err.status = 400;
      throw err;
    }

    const users = await User.findAll({ where: { email: emailUser } });

    if (users.length > 0) {
      const tokenGenerated = jwt.sign({
        exp: Math.floor(Date.now() / 1000) + (60 * 60),
        data: { email: emailUser, secureId: generateStr(3) },
        secureId: generateStr(),
      }, process.env.TOKEN_RESET_PASSWORD);

      sendMail(
        emailUser,
        'Permintaan reset password',
        templateMail(
          `${process.env.URL_CLIENT}/reset-password?token=${tokenGenerated}&email=${emailUser}`,
          'Kamu lupa password aplikasi aksara? nih tak beri link reset password. Kalo bukan kamu yang meminta request lupa password abaikan saja ya email ini.',
        ),
      );
    } else {
      const err = Error('Sayang sekali, email kamu belum terdaftar. Silahkan daftar dahulu');
      err.status = 401;
      throw err;
    }

    res.status(200).json({
      msg: 'Yeay, Silahkan cek email kamu. Cek di inbox atau junk (spam) ya',
    });
  } catch (err) {
    next(err);
  }
};

const action = async (req, res, next) => {
  try {
    const { token, email, password } = req.body;

    if (token && email && password) {
      const user = await jwt.verify(token, process.env.TOKEN_RESET_PASSWORD);
      if (user.data.email !== email) {
        const err = Error('Akses ditolak');
        err.status = 401;
        throw err;
      }
    } else {
      const err = Error('Silahkan input parameter sesuai email yang dikirim');
      err.status = 400;
      throw err;
    }

    const generatedPassword = await new Promise((resolve, reject) => {
      bcrypt.genSalt(parseInt(process.env.SALT_ROUNDS, 10), (err, salt) => {
        if (err) reject(err);
        bcrypt.hash(password, salt, (error, hash) => {
          if (error) reject(error);
          else resolve(hash);
        });
      });
    });

    await User.update({
      password: generatedPassword,
    }, { where: { email: { [Sequelize.Op.eq]: email } } });

    res.status(200).json({
      msg: 'Yeay, Silahkan login dengan password baru kamu',
    });
  } catch (err) {
    next(err);
  }
};

module.exports = { request, action };
