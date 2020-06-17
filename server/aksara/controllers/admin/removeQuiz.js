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

    const removedQuiz = await Quiz.destroy({
      where: {
        id: idData,
      },
    });

    if (!removedQuiz) {
      throw Error('Maaf, kuis tidak ditemukan');
    }

    res.status(200).json({
      msg: 'Yey, kamu berhasil menghapus kuis',
    });
  } catch (err) {
    next(err);
  }
};
