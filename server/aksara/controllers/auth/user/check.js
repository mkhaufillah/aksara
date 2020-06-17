const User = require('../../../models/user');

module.exports = async (req, res, next) => {
  try {
    const emailUser = req.query.email;
    if (!emailUser) {
      const err = Error('Kamu belum memasukkan email');
      err.status = 400;
      throw err;
    }

    const users = await User.findAll({ where: { email: emailUser } });
    let message = 'Email kamu terdaftar, silahkan masukkan password';
    if (users.length <= 0) message = 'Email kamu belum terdaftar, silahkan membuat password terlebih dahulu';

    res.status(200).json({
      msg: message,
      isFound: (users.length > 0),
    });
  } catch (err) {
    next(err);
  }
};
