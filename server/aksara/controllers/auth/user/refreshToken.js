const jwt = require('jsonwebtoken');
const generateStr = require('../../../services/randomStr');

module.exports = async (req, res, next) => {
  try {
    const { user, admin } = req;
    if (!user && !admin) {
      const err = Error('Maaf, kamu tidak memiliki akses');
      err.status = 400;
      throw err;
    }

    let tokenGenerated;
    if (user) {
      tokenGenerated = jwt.sign({
        exp: Math.floor(Date.now() / 1000) + (60 * 60 * 24 * 7),
        data: user,
        secureId: generateStr(),
      }, process.env.TOKEN_USER);
    }

    if (admin) {
      tokenGenerated = jwt.sign({
        exp: Math.floor(Date.now() / 1000) + (60 * 60 * 6),
        data: admin,
        secureId: generateStr(),
      }, process.env.TOKEN_ADMIN);
    }

    res.status(200).json({
      msg: 'Yey, sesi kamu berhasil diperbarui',
      token: tokenGenerated,
    });
  } catch (err) {
    next(err);
  }
};
