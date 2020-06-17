const { sequelize } = require('../database');

module.exports = async (req, res, next) => {
  try {
    const { user } = req;
    if (!user) {
      const err = Error('Maaf, kamu tidak memiliki akses');
      err.status = 400;
      throw err;
    }

    await sequelize.query('SET @rank := 0;');
    const data = await sequelize
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

    res.status(200).json({ content: data[0] });
  } catch (err) {
    next(err);
  }
};
