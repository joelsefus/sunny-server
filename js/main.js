var ApiRoutes, HOST, Middleware, PORT, UseMiddleware, UserAuth, app, auth, compiler, config, db, ensureLogin, express, gzipStatic, http, middleware, os, pages, path, server, sql, webpack, webpackManifest;

os = require('os');

path = require('path');

http = require('http');

express = require('express');

gzipStatic = require('connect-gzip-static');

ensureLogin = require('connect-ensure-login');

Middleware = require('./middleware');

UserAuth = require('./userauth');

ApiRoutes = require('./apiroutes');

db = require('./models');

pages = require('./pages');

webpackManifest = require('../build/manifest.json');

sql = db.sequelize;

UseMiddleware = false || process.env.__DEV__ === 'true';

PORT = process.env.NODE_PORT || 8081;

HOST = process.env.NODE_IP || os.hostname();

app = express();

auth = UserAuth.auth;

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

app.get('/', pages.make_page('index'));

app.get('/sunny', auth, pages.make_page('sunny'));

server = http.createServer(app);

sql.sync().then(function() {
  return server.listen(PORT, HOST, function() {
    return console.log("Server running on " + HOST + ":" + PORT + ".");
  });
});
