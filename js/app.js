var APIPATH, HOST, PORT, Sequelize, app, bodyParser, clientPath, clientResource, db, documentPath, documentResource, epilogue, express, http, os, path, server, sql;

os = require('os');

path = require('path');

http = require('http');

Sequelize = require('sequelize');

epilogue = require('epilogue');

express = require('express');

bodyParser = require('body-parser');

PORT = process.env.NODE_PORT || 8081;

HOST = process.env.NODE_IP || os.hostname();

db = require('./models');

sql = db.sequelize;

sql["import"]('./models/client');

sql["import"]('./models/document');

app = express();

app.use(bodyParser.json());

app.use(bodyParser.urlencoded({
  extended: false
}));

server = http.createServer(app);

app.get('/health', function(req, res, next) {
  return res.end();
});

app.get('/', function(req, res, next) {
  var beautify, index, manifest, page, theme;
  manifest = require('../build/manifest.json');
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

sql.sync().then(function() {
  return server.listen(PORT, HOST, function() {
    return console.log("Server running on " + HOST + ":" + PORT + ".");
  });
});
