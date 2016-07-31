var APIPATH, HOST, PORT, Sequelize, clientPath, clientResource, config_module, db, documentPath, documentResource, env, epilogue, os, path, respond, restify, server, sql;

os = require('os');

path = require('path');

Sequelize = require('sequelize');

epilogue = require('epilogue');

restify = require('restify');

env = process.env.NODE_ENV || 'development';

config_module = require('./config');

PORT = process.env.NODE_PORT || 8081;

HOST = process.env.NODE_IP || os.hostname();

db = require('./models');

sql = db.sequelize;

sql["import"]('./models/client');

sql["import"]('./models/document');

server = restify.createServer();

server.get('/health', function(req, res, next) {
  return res.end();
});

server.use(restify.queryParser());

server.use(restify.bodyParser());

epilogue.initialize({
  app: server,
  sequelize: sql
});

respond = function(request, response, next) {
  return response.send("Hello " + request.params.name + "@@@@!");
};

server.get('/hello/:name', respond);

server.head('/hello/:name', respond);

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

server.get(/\/assets\/?.*/, restify.serveStatic({
  directory: path.resolve(__dirname, '..')
}));

console.log('__dirname', __dirname);

console.log('join-assets', path.join(__dirname, '..', 'assets'));

console.log('resolve-assets', path.resolve(__dirname, '..', 'assets'));

console.log('resolve-up', path.resolve(__dirname, '..'));

server.get(/^\/build\//, restify.serveStatic({
  directory: path.resolve(__dirname, '..')
}));

server.get(/\/fonts\//, restify.serveStatic({
  directory: path.resolve(__dirname, '..')
}));

server.get('/', function(req, res, next) {
  var beautify, index, manifest, page, theme;
  manifest = require('../build/manifest.json');
  theme = 'cornsilk';
  page = require('./index');
  beautify = require('js-beautify').html;
  index = page(manifest, theme);
  res.writeHead(200, {
    'Content-Length': Buffer.byteLength(index),
    'Content-Type': 'text/html'
  });
  res.write(index);
  res.end();
  return next();
});

sql.sync().then(function() {
  return server.listen(PORT, HOST, function() {
    return console.log("Server running on " + HOST + ":" + PORT + ".");
  });
});
