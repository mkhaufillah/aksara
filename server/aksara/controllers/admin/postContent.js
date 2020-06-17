const Content = require('../../models/content');
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
    let copyData = req.body.copy;
    if (!copyData) {
      copyData = null;
    }
    let linkData = req.body.link;
    if (!linkData) {
      linkData = null;
    }
    const subDocumentIdData = req.body.subDocumentId;
    if (!subDocumentIdData) {
      const err = Error('Kamu belum memasukkan id sub dokumen');
      err.status = 400;
      throw err;
    }
    const dialogDatas = req.body.dialogs;
    if (!dialogDatas) {
      const err = Error('Kamu belum memasukkan dialog');
      err.status = 400;
      throw err;
    }
    dialogDatas.forEach((e) => {
      if (!e.content) {
        const err = Error('Dialog yang kamu masukkan invalid');
        err.status = 400;
        throw err;
      }
    });

    let createdContent = null;
    const createdDialogs = await sequelize.transaction().then(t => Content.create({
      title: titleData,
      content: contentData,
      akrab: akrabData,
      santun: santunData,
      link: linkData,
      copy: copyData,
      subDocumentId: subDocumentIdData,
    }, { transaction: t }).then((content) => {
      createdContent = content;
      const dialogs = [];
      dialogDatas.forEach((e) => {
        dialogs.push(
          Dialog.create({
            content: e.content,
            contentId: content.id,
          }, { transaction: t }),
        );
      });
      return Promise.all(dialogs);
    }).then((content) => {
      t.commit();
      return content;
    }).catch((err) => {
      t.rollback();
      throw err;
    }));

    res.status(200).json({
      msg: 'Yey, kamu berhasil membuat konten',
      content: createdContent,
      dialogs: createdDialogs,
    });
  } catch (err) {
    next(err);
  }
};
