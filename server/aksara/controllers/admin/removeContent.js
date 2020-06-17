const Content = require('../../models/content');

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

    const removedContent = await Content.destroy({
      where: {
        id: idData,
      },
    });

    if (!removedContent) {
      throw Error('Maaf, konten tidak ditemukan');
    }

    res.status(200).json({
      msg: 'Yey, kamu berhasil menghapus konten',
    });
  } catch (err) {
    next(err);
  }
};
