const Document = require('../../models/document');
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
      const err = Error('Kamu belum memasukkan judul dokumen');
      err.status = 400;
      throw err;
    }

    const createdDoc = await sequelize.transaction(t => Document.create({
      title: titleData,
    }, { transaction: t }));

    res.status(200).json({
      msg: 'Yey, kamu berhasil membuat dokumen',
      document: createdDoc,
    });
  } catch (err) {
    next(err);
  }
};
