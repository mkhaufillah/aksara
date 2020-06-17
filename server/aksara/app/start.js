require('dotenv').config();
const express = require('express');

const app = express();

app.use(require('../middleware'));
app.use(require('../controllers/router'));

app.listen(
  process.env.PORT,
  // eslint-disable-next-line no-console
  () => console.log(`${process.env.NODE_ENV} mode listening on port ${process.env.PORT}!`),
);
