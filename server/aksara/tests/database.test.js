require('dotenv').config();
const { sequelize } = require('../database');

function connection(callback) {
  sequelize.authenticate()
    .then(() => callback(1))
    .catch(() => {
      callback(0);
    });
}

test('Test database connection', (done) => {
  function callback(data) {
    expect(data).toBe(1);
    done();
  }
  connection(callback);
});
