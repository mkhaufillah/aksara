const { Sequelize, sequelize } = require('../database');

const { Model } = Sequelize;

class Content extends Model {}

Content.init({
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
  content: {
    type: Sequelize.TEXT,
    allowNull: true,
  },
  santun: {
    type: Sequelize.TEXT,
    allowNull: true,
  },
  akrab: {
    type: Sequelize.TEXT,
    allowNull: true,
  },
  copy: {
    type: Sequelize.TEXT,
    allowNull: true,
  },
  link: {
    type: Sequelize.TEXT,
    allowNull: true,
  },
}, {
  sequelize,
  modelName: 'content',
  timestamps: true,
});

Content.hasMany(require('./quiz'), {
  onDelete: 'cascade',
  hooks: true,
});
Content.hasMany(require('./dialog'), {
  onDelete: 'cascade',
  hooks: true,
});

module.exports = Content;
