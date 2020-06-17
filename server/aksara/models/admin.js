const { Sequelize, sequelize } = require('../database');

const { Model } = Sequelize;

class Admin extends Model {}

Admin.init({
  id: {
    type: Sequelize.INTEGER,
    allowNull: false,
    autoIncrement: true,
    primaryKey: true,
  },
  email: {
    type: Sequelize.STRING,
    allowNull: false,
    unique: true,
    validate: {
      isEmail: true,
      notNull: true,
      notEmpty: true,
    },
  },
  password: {
    type: Sequelize.STRING,
    allowNull: false,
    validate: {
      notNull: true,
      notEmpty: true,
    },
  },
}, {
  sequelize,
  modelName: 'admin',
  timestamps: true,
});

module.exports = Admin;
