const express = require('express');

const router = express.Router();

router.get('/check', require('./check'));
router.post('/login', require('./login'));
router.post('/register', require('./register'));
router.get('/refresh-token', require('./refreshToken'));
router.post('/request-reset-password', require('./resetPassword').request);
router.post('/action-reset-password', require('./resetPassword').action);
router.post('/account-activation', require('./accountActivation'));
router.post('/update-bio', require('./updateBio'));

module.exports = router;
