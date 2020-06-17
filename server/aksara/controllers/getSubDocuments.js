const SubDocument = require('../models/subDocument');

module.exports = async (req, res, next) => {
  try {
    const { user, admin } = req;
    if (!user && !admin) {
      const err = Error('Maaf, kamu tidak memiliki akses');
      err.status = 400;
      throw err;
    }
    const documentIdData = req.query.documentId;
    if (!documentIdData) {
      const err = Error('Kamu belum memasukkan id document');
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

    const subDocumentDatas = await SubDocument.findAll({
      where: { documentId: documentIdData },
      limit: limitData,
      offset: offsetData,
      order: [['title', 'ASC']],
    });

    res.status(200).json({ subDocuments: subDocumentDatas });
  } catch (err) {
    next(err);
  }
};
