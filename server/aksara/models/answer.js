const { Sequelize, sequelize } = require('../database');

const { Model } = Sequelize;

class Answer extends Model {}

Answer.init({
  id: {
    type: Sequelize.INTEGER,
    allowNull: false,
    autoIncrement: true,
    primaryKey: true,
  },
  title: {
    type: Sequelize.STRING,
    allowNull: false,
    validate: {
      notNull: true,
      notEmpty: true,
    },
  },
  answer: {
    type: Sequelize.TEXT,
    allowNull: false,
    validate: {
      notNull: true,
      notEmpty: true,
    },
  },
  color: {
    type: Sequelize.STRING,
    allowNull: false,
    validate: {
      notNull: true,
      notEmpty: true,
    },
  },
  textColor: {
    type: Sequelize.STRING,
    allowNull: false,
    validate: {
      notNull: true,
      notEmpty: true,
    },
  },
  isCorrect: {
    type: Sequelize.BOOLEAN,
    allowNull: false,
    validate: {
      notNull: false,
    },
  },
}, {
  sequelize,
  modelName: 'answer',
  timestamps: true,
});

module.exports = Answer;
