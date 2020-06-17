const { Sequelize, sequelize } = require('../database');

const { Model } = Sequelize;

class SubDocument extends Model {}

SubDocument.init({
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
  modelName: 'subDocument',
  timestamps: true,
});

SubDocument.hasMany(require('./content'), {
  onDelete: 'cascade',
  hooks: true,
});

module.exports = SubDocument;
