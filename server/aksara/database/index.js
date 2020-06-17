const Sequelize = require('sequelize');

const db = {};

const sequelize = new Sequelize(
  process.env.DB_NAME,
  process.env.DB_USERNAME,
  process.env.DB_PASSWORD,
  {
    host: process.env.DB_HOSTNAME,
    dialect: process.env.DB_DIALECT,
    port: process.env.DB_PORT,
  },
);

db.sequelize = sequelize;
db.Sequelize = Sequelize;

module.exports = db;
