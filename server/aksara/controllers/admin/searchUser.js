const User = require('../../models/user');
const { Sequelize } = require('../../database');

module.exports = async (req, res, next) => {
  try {
    const { admin } = req;
    if (!admin) {
      const err = Error('Maaf, kamu tidak memiliki akses');
      err.status = 400;
      throw err;
    }
    const pageData = req.query.page;
    if (!pageData) {
      const err = Error('Kamu belum memasukkan data page');
      err.status = 400;
      throw err;
    }
    const keywordData = req.query.keyword;
    if (!keywordData) {
      const err = Error('Kamu belum memasukkan keyword');
      err.status = 400;
      throw err;
    }
    const limitData = 20;
    let offsetData = 0;
    offsetData += limitData * pageData;

    const userDatas = await User.findAll({
      attributes: { exclude: ['password'] },
      where: {
        [Sequelize.Op.or]: [
          { name: { [Sequelize.Op.like]: `%${keywordData}%` } },
          { email: { [Sequelize.Op.like]: `%${keywordData}%` } },
        ],
      },
      limit: limitData,
      offset: offsetData,
      order: [['email', 'ASC']],
    });

    res.status(200).json({ users: userDatas });
  } catch (err) {
    next(err);
  }
};
