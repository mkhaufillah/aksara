const Dialog = require('../../models/dialog');
const { sequelize } = require('../../database');

module.exports = async (req, res, next) => {
  try {
    const { admin } = req;
    if (!admin) {
      const err = Error('Maaf, kamu tidak memiliki akses');
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

    const createdDialog = await sequelize.transaction(t => Dialog.create({
      content: contentData,
      contentId: contentIdData,
    }, { transaction: t }));

    res.status(200).json({
      msg: 'Yey, kamu berhasil membuat dialog',
      document: createdDialog,
    });
  } catch (err) {
    next(err);
  }
};
