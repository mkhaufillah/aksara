module.exports = async (req, res, next) => {
  try {
    const { user, admin } = req;
    if (!user && !admin) {
      const err = Error('Maaf, kamu tidak memiliki akses');
      err.status = 400;
      throw err;
    }
    let dataGenerate = user;
    if (admin) dataGenerate = admin;

    res.status(200).json({ data: dataGenerate });
  } catch (err) {
    next(err);
  }
};
