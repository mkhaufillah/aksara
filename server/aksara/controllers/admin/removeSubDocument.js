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

    const removedSubDocument = await SubDocument.destroy({
      where: {
        id: idData,
      },
    });

    if (!removedSubDocument) {
      throw Error('Maaf, sub dokumen tidak ditemukan');
    }

    res.status(200).json({
      msg: 'Yey, kamu berhasil menghapus sub dokumen',
    });
  } catch (err) {
    next(err);
  }
};
