const Subdocument = require('../../models/subDocument');
const { sequelize } = require('../../database');

module.exports = async (req, res, next) => {
  try {
    const { admin } = req;
    if (!admin) {
      const err = Error('Maaf, kamu tidak memiliki akses');
      err.status = 400;
      throw err;
    }
    const titleData = req.body.title;
    if (!titleData) {
      const err = Error('Kamu belum memasukkan judul sub dokumen');
      err.status = 400;
      throw err;
    }
    const documentIdData = req.body.documentId;
    if (!documentIdData) {
      const err = Error('Kamu belum memasukkan id dokumen');
      err.status = 400;
      throw err;
    }

    const createdSubDoc = await sequelize.transaction(t => Subdocument.create({
      title: titleData,
      documentId: documentIdData,
    }, { transaction: t }));

    res.status(200).json({
      msg: 'Yey, kamu berhasil membuat sub dokumen',
      subDocument: createdSubDoc,
    });
  } catch (err) {
    next(err);
  }
};
