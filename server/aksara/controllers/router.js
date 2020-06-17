const express = require('express');

const router = express.Router();

router.use('/auth', require('./auth/router'));
router.use('/admin', require('./admin/router'));

router.get('/get-achievement', require('./getAchievement'));
router.get('/get-contents', require('./getContents'));
router.get('/get-documents', require('./getDocuments'));
router.get('/get-history', require('./getHistory'));
router.get('/get-leaderboard', require('./getLeaderboard'));
router.get('/get-quizes', require('./getQuizes'));
router.get('/get-sub-documents', require('./getSubDocuments'));
router.get('/get-bio', require('./getBio'));
router.get('/search-document', require('./searchDocument'));
router.get('/search-sub-document', require('./searchSubDocument'));
router.get('/search-content', require('./searchContent'));
router.post('/send-achievement', require('./sendAchievement'));

router.get('/show', require('./show'));

router.use((_req, _res, next) => {
  const err = new Error('URL tidak tersedia');
  err.status = 404;
  next(err);
});

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
