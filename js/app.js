var APIPATH, HOST, PORT, Sequelize, Strategy, UseMiddleware, app, bodyParser, clientPath, clientResource, compiler, config, cookieParser, db, documentPath, documentResource, ensureLogin, epilogue, express, expressSession, gzipStatic, http, middleware, morgan, os, passport, path, server, sql, webpack;

os = require('os');

path = require('path');

http = require('http');

Sequelize = require('sequelize');

epilogue = require('epilogue');

express = require('express');

bodyParser = require('body-parser');

cookieParser = require('cookie-parser');

expressSession = require('express-session');

morgan = require('morgan');

gzipStatic = require('connect-gzip-static');

passport = require('passport');

Strategy = require('passport-local').Strategy;

ensureLogin = require('connect-ensure-login');

PORT = process.env.NODE_PORT || 8081;

HOST = process.env.NODE_IP || os.hostname();

db = require('./models');

sql = db.sequelize;

sql["import"]('./models/user');

sql["import"]('./models/client');

sql["import"]('./models/document');

UseMiddleware = false && process.env.__DEV__ === 'true';

passport.use(new Strategy(function(username, password, cb) {
  return sql.models.user.findOne({
    where: {
      name: username
    }
  }).then(function(user) {
    if (!user) {
      cb(null, false);
    }
    if (user.password !== password) {
      return cb(null, user);
    }
  });
}));

passport.serializeUser(function(user, cb) {
  return cb(null, user.id);
});

passport.deserializeUser(function(id, cb) {
  var umodel;
  return umodel = db.models.user.findById(id, function(err, user) {
    if (err) {
      cb(err);
    }
    return cb(null, user);
  });
});

app = express();

app.use(morgan('combined'));

app.use(cookieParser());

app.use(bodyParser.json());

app.use(bodyParser.urlencoded({
  extended: false
}));

app.use(expressSession({
  secret: 'please set me from outside config',
  resave: false,
  saveUninitialized: false
}));

app.use(passport.initialize());

app.use(passport.session());

app.get('/login', function(req, res) {});

app.post('/login', passport.authenticate('local', {
  failureRedirect: '/login'
}), function(req, res) {
  return res.redirect('/');
});

app.get('/logout', function(req, res) {
  req.logout();
  return res.redirect('/');
});

app.get('/current/user', function(req, res) {
  return res.json(req.user);
});

app.get('/health', function(req, res, next) {
  return res.end();
});

app.use('/assets', express["static"](path.join(__dirname, '../assets')));

if (UseMiddleware) {
  require('coffee-script/register');
  webpack = require('webpack');
  middleware = require('webpack-dev-middleware');
  config = require('../webpack.config');
  compiler = webpack(config);
  app.use(middleware(compiler, {
    publicPath: config.output.publicPath,
    stats: {
      colors: true
    }
  }));
  console.log("Soon to use webpack middleware");
} else {
  app.use('/build', gzipStatic(path.join(__dirname, '../build')));
}

app.get('/', function(req, res, next) {
  var beautify, index, manifest, page, theme;
  if (UseMiddleware) {
    manifest = {
      'app.js': 'app.js'
    };
  } else {
    manifest = require('../build/manifest.json');
  }
  theme = 'cornsilk';
  page = require('./index');
  beautify = require('js-beautify').html;
  index = page(manifest, theme);
  index = beautify(index);
  res.writeHead(200, {
    'Content-Length': Buffer.byteLength(index),
    'Content-Type': 'text/html'
  });
  res.write(index);
  res.end();
  return next();
});

epilogue.initialize({
  app: app,
  sequelize: sql
});

APIPATH = '/api/dev';

clientPath = APIPATH + "/sunny/clients";

clientResource = epilogue.resource({
  model: sql.models.client,
  endpoints: [clientPath, clientPath + "/:id"]
});

documentPath = APIPATH + "/sitedocuments";

documentResource = epilogue.resource({
  model: sql.models.document,
  endpoints: [documentPath, documentPath + "/:name"]
});

server = http.createServer(app);

sql.sync().then(function() {
  return server.listen(PORT, HOST, function() {
    return console.log("Server running on " + HOST + ":" + PORT + ".");
  });
});
