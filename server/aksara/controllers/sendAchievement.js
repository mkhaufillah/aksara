const UserContent = require('../models/userContent');
const User = require('../models/user');
const { sequelize, Sequelize } = require('../database');

module.exports = async (req, res, next) => {
  try {
    const { user } = req;
    if (!user) {
      const err = Error('Maaf, kamu tidak memiliki akses');
      err.status = 400;
      throw err;
    }
    const contentIdData = req.body.contentId;
    if (!contentIdData) {
      const err = Error('Kamu belum memasukkan id konten');
      err.status = 400;
      throw err;
    }
    const quizResultData = req.body.quizResult;
    if (!quizResultData) {
      const err = Error('Kamu belum memasukkan hasil kuis');
      err.status = 400;
      throw err;
    }
    const timeStartData = req.body.timeStart;
    if (!timeStartData) {
      const err = Error('Kamu belum memasukkan waktu mulai');
      err.status = 400;
      throw err;
    }
    const timeEndData = req.body.timeEnd;
    if (!timeEndData) {
      const err = Error('Kamu belum memasukkan waktu berakhir');
      err.status = 400;
      throw err;
    }
    const signatureData = req.body.signature;
    if (!signatureData) {
      const err = Error('Kamu belum memasukkan signature');
      err.status = 400;
      throw err;
    }

    if (quizResultData < 2) {
      const err = Error('Maaf kamu gagal menyelesaikan soal');
      err.status = 400;
      throw err;
    }

    await sequelize.query('SET @rank := 0;');
    const dataAchievementOld = await sequelize
      .query(`
        SELECT *, (@rank := 0) AS reset FROM (
          SELECT *, @rank := @rank + 1 AS rank FROM (
              SELECT users.id, users.level,
              CAST(COALESCE(SUM(userContents.point), 0) AS UNSIGNED) as point
              FROM users LEFT JOIN userContents
              ON users.id = userContents.userId
              WHERE isActive = true GROUP BY users.id
              ORDER BY level DESC, SUM(userContents.point) DESC
          ) AS data
        ) AS dataRank WHERE id=${user.id};
      `, { type: sequelize.QueryTypes.SELECT });

    const pointAddData = (quizResultData * 25) + (
      Math.round(130000 / (timeEndData - timeStartData))
    );
    const realLevel = (Math.floor((dataAchievementOld[0].point + pointAddData) / 200));
    if (realLevel > dataAchievementOld[0].level) {
      await User.update({
        level: realLevel,
      }, { where: { id: { [Sequelize.Op.eq]: user.id } } });
    }

    const modPointData = (200 - ((dataAchievementOld[0].point + pointAddData) % 200));

    await sequelize.transaction(t => UserContent.create({
      userId: user.id,
      contentId: contentIdData,
      point: pointAddData,
      completedQuiz: quizResultData,
      token: signatureData,
    }, { transaction: t }));

    await sequelize.query('SET @rank := 0;');
    const dataAchievementNew = await sequelize
      .query(`
        SELECT *, (@rank := 0) AS reset FROM (
          SELECT *, (@rank := @rank + 1) AS rank FROM (
              SELECT users.id, users.level,
              CAST(COALESCE(SUM(userContents.point), 0) AS UNSIGNED) as point
              FROM users LEFT JOIN userContents
              ON users.id = userContents.userId
              WHERE isActive = true GROUP BY users.id
              ORDER BY level DESC, SUM(userContents.point) DESC
          ) AS data
        ) AS dataRank WHERE id=${user.id};
      `, { type: sequelize.QueryTypes.SELECT });

    const rankAddData = dataAchievementNew[0].rank - dataAchievementOld[0].rank;

    res.status(200).json({
      content: {
        pointAdd: pointAddData,
        rankAdd: rankAddData,
        levelNow: realLevel,
        modPoint: modPointData,
      },
    });
  } catch (err) {
    next(err);
  }
};
