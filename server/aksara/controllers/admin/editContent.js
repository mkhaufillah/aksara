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
    const titleData = req.body.title;
    if (!titleData) {
      const err = Error('Kamu belum memasukkan judul konten');
      err.status = 400;
      throw err;
    }
    let contentData = req.body.content;
    if (!contentData) {
      contentData = null;
    }
    let akrabData = req.body.akrab;
    if (!akrabData) {
      akrabData = null;
    }
    let santunData = req.body.santun;
    if (!santunData) {
      santunData = null;
    }
    let linkData = req.body.link;
    if (!linkData) {
      linkData = null;
    }
    let copyData = req.body.copy;
    if (!copyData) {
      copyData = null;
    }
    const subDocumentIdData = req.body.subDocumentId;
    if (!subDocumentIdData) {
      const err = Error('Kamu belum memasukkan id sub dokumen');
      err.status = 400;
      throw err;
    }

    const updatedContent = await Content.update({
      title: titleData,
      content: contentData,
      akrab: akrabData,
      santun: santunData,
      link: linkData,
      copy: copyData,
      subDocumentId: subDocumentIdData,
    }, { where: { id: idData } });

    if (!updatedContent[0]) {
      throw Error('Maaf, konten tidak ditemukan');
    }

    res.status(200).json({
      msg: 'Yey, kamu berhasil update konten',
    });
  } catch (err) {
    next(err);
  }
};
