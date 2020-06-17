require('dotenv').config();
const bcrypt = require('bcrypt');
const Admin = require('../models/admin');
const { sequelize } = require('../database');

const register = async () => {
  try {
    const emailAdmin = process.env.EMAIL;
    if (!emailAdmin) {
      const err = Error('Kamu belum memasukkan email');
      err.status = 400;
      throw err;
    }
    const passwordAdmin = process.env.PASSWORD;
    if (!passwordAdmin) {
      const err = Error('Kamu belum memasukkan password');
      err.status = 400;
      throw err;
    }

    const generatedPassword = await new Promise((resolve, reject) => {
      bcrypt.genSalt(parseInt(process.env.SALT_ROUNDS, 10), (err, salt) => {
        if (err) reject(err);
        bcrypt.hash(passwordAdmin, salt, (error, hash) => {
          if (error) reject(error);
          else resolve(hash);
        });
      });
    });

    const createdAdmin = await sequelize.transaction(t => Admin.create({
      email: emailAdmin,
      password: generatedPassword,
    }, { transaction: t }));

    createdAdmin.password = '*********';

    // eslint-disable-next-line no-console
    console.log('Yey, kamu berhasil register');
  } catch (err) {
    // eslint-disable-next-line no-console
    console.log(err.message);
  }
};

register();
