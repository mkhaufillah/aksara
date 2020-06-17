const jwt = require('jsonwebtoken');

module.exports = async (req, _res, next) => {
  try {
    if (req.user || req.admin) {
      const err = Error('Token tidak valid');
      err.status = 401;
      throw err;
    }

    const { token, authorization } = req.headers;

    if (authorization) {
      try {
        const user = await jwt.verify(authorization, process.env.TOKEN_USER);
        req.user = user.data;
      } catch (_err) {
        try {
          const admin = await jwt.verify(authorization, process.env.TOKEN_ADMIN);
          req.admin = admin.data;
        } catch (err) {
          throw err;
        }
      }
    }

    if (token) {
      await jwt.verify(token, process.env.TOKEN_HEAD);
      next();
    } else {
      const err = Error('Token tidak valid');
      err.status = 401;
      throw err;
    }
  } catch (err) {
    if (process.env.NODE_ENV === 'production') {
      const error = Error('Token tidak valid');
      error.status = 401;
      next(error);
    } else next(err);
  }
};
