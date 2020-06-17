const UserContent = require('../models/userContent');

module.exports = async (req, res, next) => {
  try {
    const { user } = req;
    if (!user) {
      const err = Error('Maaf, kamu tidak memiliki akses');
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

    const userContentDatas = await UserContent.findAll({
      where: { userId: user.id },
      attributes: ['point', 'completedQuiz', 'createdAt'],
      limit: limitData,
      offset: offsetData,
      order: [['createdAt', 'DESC']],
    });

    res.status(200).json({ histories: userContentDatas });
  } catch (err) {
    next(err);
  }
};
