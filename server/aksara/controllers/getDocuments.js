const Document = require('../models/document');

module.exports = async (req, res, next) => {
  try {
    const { user, admin } = req;
    if (!user && !admin) {
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
    const limitData = 20;
    let offsetData = 0;
    offsetData += limitData * pageData;

    const documentDatas = await Document.findAll({
      limit: limitData,
      offset: offsetData,
      order: [['title', 'ASC']],
    });

    res.status(200).json({ documents: documentDatas });
  } catch (err) {
    next(err);
  }
};
