var bodyParser, cookieParser, expressSession, httpsRedirect, morgan, setup;

bodyParser = require('body-parser');

cookieParser = require('cookie-parser');

expressSession = require('express-session');

morgan = require('morgan');

httpsRedirect = require('express-https-redirect');

setup = function(app) {
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
  if ('__DEV__' in process.env && process.env.__DEV__ === 'true') {
    return console.log('skipping httpsRedirect');
  } else {
    return app.use('/', httpsRedirect());
  }
};

module.exports = {
  setup: setup
};
