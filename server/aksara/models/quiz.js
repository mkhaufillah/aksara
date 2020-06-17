const { Sequelize, sequelize } = require('../database');

const { Model } = Sequelize;

class Quiz extends Model {}

Quiz.init({
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
  question: {
    type: Sequelize.TEXT,
    allowNull: false,
    validate: {
      notNull: true,
      notEmpty: true,
    },
  },
}, {
  sequelize,
  modelName: 'quiz',
  timestamps: true,
});

Quiz.hasMany(require('./answer'), {
  onDelete: 'cascade',
  hooks: true,
});

module.exports = Quiz;
