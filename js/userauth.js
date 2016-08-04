var Strategy, auth, bcrypt, db, passport, setup, sql;

passport = require('passport');

Strategy = require('passport-local').Strategy;

bcrypt = require('bcrypt');

db = require('./models');

sql = db.sequelize;

passport.use(new Strategy(function(username, password, done) {
  return sql.models.user.findOne({
    where: {
      name: username
    }
  }).then(function(user) {
    var result;
    if (!user) {
      done(null, false);
      return;
    }
    result = bcrypt.compareSync(password, user.password);
    return bcrypt.compare(password, user.password, function(err, res) {
      if (res) {
        return done(null, user);
      } else {
        return done(null, false);
      }
    });
  });
}));

passport.serializeUser(function(user, done) {
  return done(null, user.id);
});

passport.deserializeUser(function(id, done) {
  return sql.models.user.findById(id).then(function(user) {
    return done(null, user);
  });
});

auth = function(req, res, next) {
  if (req.isAuthenticated()) {
    return next();
  } else {
    return res.redirect('/');
  }
};

setup = function(app) {
  app.use(passport.initialize());
  app.use(passport.session());
  app.get('/login', function(req, res) {
    res.redirect('/');
  });
  app.post('/login', passport.authenticate('local', {
    failureRedirect: '/'
  }), function(req, res) {
    return res.redirect('/');
  });
  return app.get('/logout', function(req, res) {
    req.logout();
    res.redirect('/');
  });
};

module.exports = {
  setup: setup,
  auth: auth
};
