const express = require('express');

const router = express.Router();

router.use('/user', require('./user/router'));
router.use('/admin', require('./admin/router'));

module.exports = router;
