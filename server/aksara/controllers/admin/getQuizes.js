const Quiz = require('../../models/quiz');
const Answer = require('../../models/answer');

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
      const err = Error('Kamu belum memasukkan id sub document');
      err.status = 400;
      throw err;
    }
    const pageData = req.query.page;
    if (!pageData) {
      const err = Error('Kamu belum memasukkan data page');
      err.status = 400;
      throw err;
    }
    const limitData = 20;
    let offsetData = 0;
    offsetData += limitData * pageData;

    const quizDatas = await Quiz.findAll({
      where: { contentId: contentIdData },
      limit: limitData,
      offset: offsetData,
      order: [['title', 'ASC']],
      include: [{ model: Answer }],
    });

    res.status(200).json({ quizes: quizDatas });
  } catch (err) {
    next(err);
  }
};
