require('dotenv').config();
const jwt = require('jsonwebtoken');
const randomStr = require('../services/randomStr');

async function generateToken() {
  try {
    const token = await jwt.sign(randomStr(), process.env.TOKEN_HEAD);
    // eslint-disable-next-line no-console
    console.log(token);
  } catch (err) {
    // eslint-disable-next-line no-console
    console.log(err.message);
  }
}

generateToken();
