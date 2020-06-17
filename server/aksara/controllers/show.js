const User = require('../models/user');
const { sequelize } = require('../database');

module.exports = async (req, res, next) => {
  try {
    const emailUser = req.query.email;
    if (!emailUser) {
      const err = Error('Kamu belum memasukkan email');
      err.status = 400;
      throw err;
    }

    const users = await User.findAll({ where: { email: emailUser } });
    const userData = users[0];
    let achievementData;
    if (users.length > 0) {
      userData.password = null;
      userData.isActive = null;
      await sequelize.query('SET @rank := 0;');
      const achievements = await sequelize
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
          ) AS dataRank WHERE id=${userData.id};
        `, { type: sequelize.QueryTypes.SELECT });
      [achievementData] = achievements;
    }

    res.status(200).json({
      user: userData,
      achievement: achievementData,
    });
  } catch (err) {
    next(err);
  }
};
