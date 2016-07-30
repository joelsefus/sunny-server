var Sequelize, clientResource, epilogue, os, respond, restify, server, server_port, sql;

os = require('os');

Sequelize = require('sequelize');

epilogue = require('epilogue');

restify = require('restify');

server_port = 8081;

sql = new Sequelize({
  dialect: 'sqlite',
  storage: 'sunny.sqlite',
  omitNull: true
});

sql["import"]('./models/client');

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

clientResource = epilogue.resource({
  model: sql.models.client,
  endpoints: ['/api/dev/sunny/clients', '/api/dev/sunny/clients/:id']
});

sql.sync().then(function() {
  return server.listen(server_port, function() {
    return console.log("Server running on port " + server_port + ".");
  });
});
