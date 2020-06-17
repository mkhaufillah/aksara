const { sequelize } = require('../database');

module.exports = async (req, res, next) => {
  try {
    const { user } = req;
    if (!user) {
      const err = Error('Maaf, kamu tidak memiliki akses');
      err.status = 400;
      throw err;
    }

    const userDatas = await sequelize
      .query(`
        SELECT users.email, users.level, users.name, users.faculty,
          users.department, users.studyProgram, users.generation, users.createdAt,
          CAST(COALESCE(SUM(userContents.point), 0) AS UNSIGNED) as point
        FROM users LEFT JOIN userContents ON users.id = userContents.userId
        WHERE isActive = true GROUP BY users.id ORDER BY level DESC, SUM(userContents.point) DESC LIMIT 50;
      `, { type: sequelize.QueryTypes.SELECT });

    res.status(200).json({ users: userDatas });
  } catch (err) {
    next(err);
  }
};
