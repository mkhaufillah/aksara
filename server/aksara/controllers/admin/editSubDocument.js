const SubDocument = require('../../models/subDocument');

module.exports = async (req, res, next) => {
  try {
    const { admin } = req;
    if (!admin) {
      const err = Error('Maaf, kamu tidak memiliki akses');
      err.status = 400;
      throw err;
    }
    const idData = req.body.id;
    if (!idData) {
      const err = Error('Kamu belum memasukkan id');
      err.status = 400;
      throw err;
    }
    const titleData = req.body.title;
    if (!titleData) {
      const err = Error('Kamu belum memasukkan title');
      err.status = 400;
      throw err;
    }
    const documentIdData = req.body.documentId;
    if (!documentIdData) {
      const err = Error('Kamu belum memasukkan id dokumen');
      err.status = 400;
      throw err;
    }

    const updatedSubDocument = await SubDocument.update({
      title: titleData,
      documentId: documentIdData,
    }, { where: { id: idData } });

    if (!updatedSubDocument[0]) {
      throw Error('Maaf, sub dokumen tidak ditemukan');
    }

    res.status(200).json({
      msg: 'Yey, kamu berhasil update sub dokumen',
    });
  } catch (err) {
    next(err);
  }
};
