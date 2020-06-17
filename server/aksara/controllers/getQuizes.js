const Quiz = require('../models/quiz');
const Answer = require('../models/answer');
const { sequelize } = require('../database');
const shuffleArr = require('../services/shuffleArr');
const UserContent = require('../models/userContent');

module.exports = async (req, res, next) => {
  try {
    const { user } = req;
    if (!user) {
      const err = Error('Maaf, kamu tidak memiliki akses');
      err.status = 400;
      throw err;
    }
    const contentIdData = req.query.contentId;
    if (!contentIdData) {
      const err = Error('Kamu belum memasukkan id konten');
      err.status = 400;
      throw err;
    }

    const userContentDatas = await UserContent.findAll({
      where: { contentId: contentIdData, userId: user.id },
    });

    if (userContentDatas.length > 0) {
      const err = Error('Maaf, anda sudah pernah menyelesaikan kuis ini');
      err.status = 500;
      throw err;
    }

    const quizDatas = await Quiz.findAll({
      where: { contentId: contentIdData },
      limit: 4,
      order: sequelize.random(),
      include: [{ model: Answer }],
    });

    if (quizDatas.length < 4) {
      const err = Error('Maaf, kuis belum tersedia');
      err.status = 500;
      throw err;
    }

    for (let i = 0; i < quizDatas.length; i += 1) {
      quizDatas[i].answers = shuffleArr(quizDatas[i].answers);
    }

    res.status(200).json({ quizes: quizDatas });
  } catch (err) {
    next(err);
  }
};
