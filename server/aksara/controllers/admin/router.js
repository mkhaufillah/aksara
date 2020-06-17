const express = require('express');

const router = express.Router();

router.post('/post-document', require('./postDocument'));
router.post('/post-sub-document', require('./postSubDocument'));
router.post('/post-content', require('./postContent'));
router.post('/post-quiz', require('./postQuiz'));
router.post('/post-dialog', require('./postDialog'));
router.post('/edit-document', require('./editDocument'));
router.post('/edit-sub-document', require('./editSubDocument'));
router.post('/edit-content', require('./editContent'));
router.post('/edit-quiz', require('./editQuiz'));
router.post('/edit-answer', require('./editAnswer'));
router.post('/edit-dialog', require('./editDialog'));
router.post('/remove-document', require('./removeDocument'));
router.post('/remove-sub-document', require('./removeSubDocument'));
router.post('/remove-content', require('./removeContent'));
router.post('/remove-quiz', require('./removeQuiz'));
router.post('/remove-dialog', require('./removeDialog'));
router.get('/get-quizes', require('./getQuizes'));
router.get('/get-users', require('./getUsers'));
router.get('/get-admins', require('./getAdmins'));
router.get('/search-quiz', require('./searchQuiz'));
router.get('/search-user', require('./searchUser'));
router.get('/search-admin', require('./searchAdmin'));

module.exports = router;
