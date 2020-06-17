require('dotenv').config();
const User = require('../models/user');
const Document = require('../models/document');
const SubDocument = require('../models/subDocument');
const Content = require('../models/content');
const Quiz = require('../models/quiz');
const Admin = require('../models/admin');
const Answer = require('../models/answer');
const UserContent = require('../models/userContent');
const Dialog = require('../models/dialog');

async function syncDb() {
  try {
    await Admin.sync({ force: true });
    await Document.sync({ force: true });
    await SubDocument.sync({ force: true });
    await Content.sync({ force: true });
    await Dialog.sync({ force: true });
    await Quiz.sync({ force: true });
    await Answer.sync({ force: true });
    await User.sync({ force: true });
    await UserContent.sync({ force: true });
  } catch (err) {
    // eslint-disable-next-line no-console
    console.log(err.message);
  }
}

syncDb();
