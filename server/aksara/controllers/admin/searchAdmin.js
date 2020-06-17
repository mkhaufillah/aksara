const Admin = require('../../models/admin');
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

    const adminDatas = await Admin.findAll({
      attributes: { exclude: ['password'] },
      where: {
        email: { [Sequelize.Op.like]: `%${keywordData}%` },
      },
      limit: limitData,
      offset: offsetData,
      order: [['email', 'ASC']],
    });

    res.status(200).json({ admins: adminDatas });
  } catch (err) {
    next(err);
  }
};
