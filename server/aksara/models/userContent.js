const { Sequelize, sequelize } = require('../database');

const { Model } = Sequelize;

class UserContent extends Model {}

UserContent.init({
  point: {
    type: Sequelize.INTEGER,
    allowNull: false,
    validate: {
      notNull: true,
    },
  },
  completedQuiz: {
    type: Sequelize.INTEGER,
    allowNull: false,
    validate: {
      notNull: true,
    },
  },
  token: {
    type: Sequelize.STRING,
    allowNull: false,
    validate: {
      notNull: true,
      notEmpty: true,
    },
  },
}, {
  sequelize,
  modelName: 'userContent',
  timestamps: true,
});

module.exports = UserContent;
