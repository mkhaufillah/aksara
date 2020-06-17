const Answer = require('../../models/answer');

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
      const err = Error('Kamu belum memasukkan judul jawaban');
      err.status = 400;
      throw err;
    }
    const answerData = req.body.answer;
    if (!answerData) {
      const err = Error('Kamu belum memasukkan jawaban');
      err.status = 400;
      throw err;
    }
    const colorData = req.body.color;
    if (!colorData) {
      const err = Error('Kamu belum memasukkan warna');
      err.status = 400;
      throw err;
    }
    const textColorData = req.body.textColor;
    if (!textColorData) {
      const err = Error('Kamu belum memasukkan warna tulisan');
      err.status = 400;
      throw err;
    }
    const isCorrectData = req.body.isCorrect;
    if (!isCorrectData) {
      const err = Error('Kamu belum memasukkan kondisi jawaban');
      err.status = 400;
      throw err;
    }
    const quizIdData = req.body.quizId;
    if (!quizIdData) {
      const err = Error('Kamu belum memasukkan id kuis');
      err.status = 400;
      throw err;
    }

    const updatedAnswer = await Answer.update({
      title: titleData,
      answer: answerData,
      color: colorData,
      textColor: textColorData,
      isCorrect: isCorrectData,
      quizId: quizIdData,
    }, { where: { id: idData } });

    if (!updatedAnswer[0]) {
      throw Error('Maaf, jawaban tidak ditemukan');
    }

    res.status(200).json({
      msg: 'Yey, kamu berhasil update jawaban',
    });
  } catch (err) {
    next(err);
  }
};
