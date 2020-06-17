const Content = require('../models/content');
const Dialog = require('../models/dialog');
const { Sequelize } = require('../database');

module.exports = async (req, res, next) => {
  try {
    const { user, admin } = req;
    if (!user && !admin) {
      const err = Error('Maaf, kamu tidak memiliki akses');
      err.status = 400;
      throw err;
    }
    const subDocumentIdData = req.query.subDocumentId;
    if (!subDocumentIdData) {
      const err = Error('Kamu belum memasukkan id sub document');
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

    const contentDatas = await Content.findAll({
      where: {
        subDocumentId: subDocumentIdData,
        title: { [Sequelize.Op.like]: `%${keywordData}%` },
      },
      include: [{ model: Dialog }],
      limit: limitData,
      offset: offsetData,
      order: [['title', 'ASC']],
    });

    res.status(200).json({ contents: contentDatas });
  } catch (err) {
    next(err);
  }
};
