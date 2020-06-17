const Dialog = require('../../models/dialog');

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

    const removedDialog = await Dialog.destroy({
      where: {
        id: idData,
      },
    });

    if (!removedDialog) {
      throw Error('Maaf, dialog tidak ditemukan');
    }

    res.status(200).json({
      msg: 'Yey, kamu berhasil menghapus dialog',
    });
  } catch (err) {
    next(err);
  }
};
