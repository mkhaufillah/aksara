const Quiz = require('../../models/quiz');
const Answer = require('../../models/answer');
const { Sequelize } = require('../../database');

module.exports = async (req, res, next) => {
  try {
    const { admin } = req;
    if (!admin) {
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
    const pageData = req.query.page;
    if (!pageData) {
      const err = Error('Kamu belum memasukkan data page');
      err.status = 400;
      throw err;
    }
    const keywordData = req.query.keyword;
    if (!keywordData) {
      const err = Error('Kamu belum memasukkan keyword');
      err.status = 400;
      throw err;
    }
    const limitData = 20;
    let offsetData = 0;
    offsetData += limitData * pageData;

    const quizDatas = await Quiz.findAll({
      where: {
        contentId: contentIdData,
        title: { [Sequelize.Op.like]: `%${keywordData}%` },
      },
      include: [{ model: Answer }],
      limit: limitData,
      offset: offsetData,
      order: [['title', 'ASC']],
    });

    res.status(200).json({ quizes: quizDatas });
  } catch (err) {
    next(err);
  }
};
