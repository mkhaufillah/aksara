const jwt = require('jsonwebtoken');
const User = require('../../../models/user');
const { Sequelize } = require('../../../database');

module.exports = async (req, res, next) => {
  try {
    const { token, email } = req.body;

    if (token && email) {
      const user = await jwt.verify(token, process.env.TOKEN_ACCOUNT_ACTIVATION);
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

    await User.update({
      isActive: true,
    }, { where: { email: { [Sequelize.Op.eq]: email } } });

    res.status(200).json({
      msg: 'Yeay, Silahkan buka aplikasi dan login',
    });
  } catch (err) {
    next(err);
  }
};
