const { Sequelize, sequelize } = require('../database');

const { Model } = Sequelize;

class User extends Model {}

User.init({
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
  level: {
    type: Sequelize.INTEGER,
    allowNull: false,
    defaultValue: 0,
    validate: {
      isInt: true,
    },
  },
  name: {
    type: Sequelize.STRING,
    allowNull: true,
  },
  faculty: {
    type: Sequelize.STRING,
    allowNull: true,
  },
  department: {
    type: Sequelize.STRING,
    allowNull: true,
  },
  studyProgram: {
    type: Sequelize.STRING,
    allowNull: true,
  },
  generation: {
    type: Sequelize.STRING,
    allowNull: true,
  },
  isActive: {
    type: Sequelize.BOOLEAN,
    allowNull: false,
    defaultValue: false,
  },
}, {
  sequelize,
  modelName: 'user',
  timestamps: true,
});

const userContent = require('./userContent');

User.belongsToMany(
  require('./content'),
  { as: 'Achievement', through: userContent },
  {
    onDelete: 'cascade',
    hooks: true,
  },
);

module.exports = User;
