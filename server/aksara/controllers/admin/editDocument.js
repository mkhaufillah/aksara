const Document = require('../../models/document');

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

    const updatedDocument = await Document.update({
      title: titleData,
    }, { where: { id: idData } });

    if (!updatedDocument[0]) {
      throw Error('Maaf, dokumen tidak ditemukan');
    }

    res.status(200).json({
      msg: 'Yey, kamu berhasil update dokumen',
    });
  } catch (err) {
    next(err);
  }
};
