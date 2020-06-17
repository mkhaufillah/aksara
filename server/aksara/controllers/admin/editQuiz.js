const Quiz = require('../../models/quiz');

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
      const err = Error('Kamu belum memasukkan judul kuis');
      err.status = 400;
      throw err;
    }
    const questionData = req.body.question;
    if (!questionData) {
      const err = Error('Kamu belum memasukkan kuis');
      err.status = 400;
      throw err;
    }
    const contentIdData = req.body.contentId;
    if (!contentIdData) {
      const err = Error('Kamu belum memasukkan id konten');
      err.status = 400;
      throw err;
    }

    const updatedQuiz = await Quiz.update({
      title: titleData,
      question: questionData,
      contentId: contentIdData,
    }, { where: { id: idData } });

    if (!updatedQuiz[0]) {
      throw Error('Maaf, kuis tidak ditemukan');
    }

    res.status(200).json({
      msg: 'Yey, kamu berhasil update kuis',
    });
  } catch (err) {
    next(err);
  }
};
