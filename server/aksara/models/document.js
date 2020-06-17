const { Sequelize, sequelize } = require('../database');

const { Model } = Sequelize;

class Document extends Model {}

Document.init({
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
}, {
  sequelize,
  modelName: 'document',
  timestamps: true,
});

Document.hasMany(require('./subDocument'), {
  onDelete: 'cascade',
  hooks: true,
});

module.exports = Document;
