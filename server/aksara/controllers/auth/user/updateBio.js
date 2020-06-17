const jwt = require('jsonwebtoken');
const User = require('../../../models/user');
const { Sequelize } = require('../../../database');
const generateStr = require('../../../services/randomStr');

module.exports = async (req, res, next) => {
  try {
    const { user } = req;

    if (!user) {
      const err = Error('Maaf, kamu tidak memiliki akses');
      err.status = 400;
      throw err;
    }

    const {
      name, faculty, department, studyProgram, generation,
    } = req.body;

    const userUpdate = {
      name: user.name,
      faculty: user.faculty,
      department: user.department,
      studyProgram: user.studyProgram,
      generation: user.generation,
    };

    if (name && name != null) {
      userUpdate.name = name;
      user.name = userUpdate.name;
    }
    if (faculty && faculty != null) {
      userUpdate.faculty = faculty;
      user.faculty = userUpdate.faculty;
    }
    if (department && department != null) {
      userUpdate.department = department;
      user.department = userUpdate.department;
    }
    if (studyProgram && studyProgram != null) {
      userUpdate.studyProgram = studyProgram;
      user.studyProgram = userUpdate.studyProgram;
    }
    if (generation && generation != null) {
      userUpdate.generation = generation;
      user.generation = userUpdate.generation;
    }

    user.secureId = generateStr();

    const tokenGenerated = jwt.sign({
      exp: Math.floor(Date.now() / 1000) + (60 * 60 * 24 * 7),
      data: user,
      secureId: generateStr(),
    }, process.env.TOKEN_USER);

    await User.update(userUpdate, {
      where: { id: { [Sequelize.Op.eq]: user.id } },
    });

    res.status(200).json({
      msg: 'Yeay, Biodata kamu berhasil diupdate',
      token: tokenGenerated,
      data: user,
    });
  } catch (err) {
    next(err);
  }
};
