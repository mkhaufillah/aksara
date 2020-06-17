const Quiz = require('../../models/quiz');
const Answer = require('../../models/answer');
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
    const answerDatas = req.body.answers;
    if (!answerDatas) {
      const err = Error('Kamu belum memasukkan jawaban');
      err.status = 400;
      throw err;
    }
    if (answerDatas.length !== 4) {
      const err = Error('Opsi jawaban harus ada 4');
      err.status = 400;
      throw err;
    }
    let check = 0;
    answerDatas.forEach((e) => {
      if (!e.title || !e.answer
        || !e.color || (e.isCorrect === undefined)
        || (e.isCorrect === null) || !e.textColor) {
        const err = Error('Data jawaban tidak valid');
        err.status = 400;
        throw err;
      }
      if (e.isCorrect) check += 1;
      if (check > 1) {
        const err = Error('Data jawaban tidak valid');
        err.status = 400;
        throw err;
      }
    });

    let createdQuiz = null;
    const createdAnswers = await sequelize.transaction().then(t => Quiz.create({
      title: titleData,
      question: questionData,
      contentId: contentIdData,
    }, { transaction: t }).then((quiz) => {
      createdQuiz = quiz;
      const answers = [];
      answerDatas.forEach((e) => {
        answers.push(
          Answer.create({
            title: e.title,
            answer: e.answer,
            color: e.color,
            textColor: e.textColor,
            isCorrect: e.isCorrect,
            quizId: quiz.id,
          }, { transaction: t }),
        );
      });
      return Promise.all(answers);
    }).then((quiz) => {
      t.commit();
      return quiz;
    }).catch((err) => {
      t.rollback();
      throw err;
    }));

    res.status(200).json({
      msg: 'Yey, kamu berhasil membuat quiz',
      quiz: createdQuiz,
      answers: createdAnswers,
    });
  } catch (err) {
    next(err);
  }
};
