const express = require('express');
const helmet = require('helmet');
const morgan = require('morgan');
const bodyParser = require('body-parser');

const router = express.Router();

router.use(helmet());
router.use(morgan('tiny'));
router.use(bodyParser.urlencoded({ extended: false }));
router.use(bodyParser.json());
router.use(require('./cors'));
router.use(require('./auth'));

// eslint-disable-next-line no-unused-vars
router.use((err, _req, res, _next) => {
  let errMsg = err.message;
  if (process.env.NODE_ENV === 'production' && !err.status) {
    errMsg = 'Sistem bermasalah, silahkan refresh halaman';
  }
  res.status(err.status || 500).json({
    err: {
      msg: errMsg,
    },
  });
});

module.exports = router;
