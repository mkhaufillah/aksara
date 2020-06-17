const { Sequelize, sequelize } = require('../database');

const { Model } = Sequelize;

class Dialog extends Model {}

Dialog.init({
  id: {
    type: Sequelize.INTEGER,
    allowNull: false,
    autoIncrement: true,
    primaryKey: true,
  },
  content: {
    type: Sequelize.TEXT,
    allowNull: false,
    validate: {
      notNull: true,
      notEmpty: true,
    },
  },
}, {
  sequelize,
  modelName: 'dialog',
  timestamps: true,
});

module.exports = Dialog;
