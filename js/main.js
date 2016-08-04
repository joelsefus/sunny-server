var ApiRoutes, HOST, Middleware, PORT, UseMiddleware, UserAuth, app, auth, compiler, config, db, ensureLogin, express, gzipStatic, http, middleware, os, pages, path, server, sql, webpack, webpackManifest;

os = require('os');

path = require('path');

http = require('http');

express = require('express');

gzipStatic = require('connect-gzip-static');

ensureLogin = require('connect-ensure-login');

Middleware = require('./middleware');

UserAuth = require('./userauth');

auth = UserAuth.auth;

ApiRoutes = require('./apiroutes');

db = require('./models');

pages = require('./pages');

console.log('pages', pages);

webpackManifest = require('../build/manifest.json');

sql = db.sequelize;

UseMiddleware = false || process.env.__DEV__ === 'true';

PORT = process.env.NODE_PORT || 8081;

HOST = process.env.NODE_IP || os.hostname();

app = express();

Middleware.setup(app);

UserAuth.setup(app);

ApiRoutes.setup(app);

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
    publicPath: '/build/',
    stats: {
      colors: true
    }
  }));
  console.log("Using webpack middleware");
} else {
  app.use('/build', gzipStatic(path.join(__dirname, '../build')));
}

app.get('/', function(req, res, next) {
  var page, theme;
  theme = 'cornsilk';
  console.log('pages-> ->', pages);
  page = pages.make_page('index', theme);
  return pages.write_page(page, res, next);
});

app.get('/sunny', auth, function(req, res, next) {
  var page, theme;
  theme = 'BlanchedAlmond';
  page = pages.make_page('sunny', theme);
  return pages.write_page(page, res, next);
});

server = http.createServer(app);

sql.sync().then(function() {
  return server.listen(PORT, HOST, function() {
    return console.log("Server running on " + HOST + ":" + PORT + ".");
  });
});
