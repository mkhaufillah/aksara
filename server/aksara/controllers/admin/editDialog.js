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
    const contentData = req.body.content;
    if (!contentData) {
      const err = Error('Kamu belum memasukkan konten');
      err.status = 400;
      throw err;
    }
    const contentIdData = req.body.contentId;
    if (!contentIdData) {
      const err = Error('Kamu belum memasukkan id konten');
      err.status = 400;
      throw err;
    }

    const updatedDialog = await Dialog.update({
      content: contentData,
      contentId: contentIdData,
    }, { where: { id: idData } });

    if (!updatedDialog[0]) {
      throw Error('Maaf, dialog tidak ditemukan');
    }

    res.status(200).json({
      msg: 'Yey, kamu berhasil update dialog',
    });
  } catch (err) {
    next(err);
  }
};
