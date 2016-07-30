os = require 'os'

Sequelize = require 'sequelize'
epilogue = require 'epilogue'
restify = require 'restify'

PORT = process.env.NODE_PORT or 8081
HOST = process.env.NODE_IP or os.hostname()



# init database object
sql = new Sequelize
  dialect: 'sqlite'
  storage: 'sunny.sqlite'
  omitNull: true

# import models
sql.import './models/client'
#Client = require './models/client'







server = restify.createServer()

# health url required for openshift
server.get '/health', (req, res, next) ->
  res.end()

server.use restify.queryParser()
server.use restify.bodyParser()


epilogue.initialize
  app: server
  sequelize: sql



respond = (request, response, next) ->
  response.send "Hello #{request.params.name}@@@@!"

server.get '/hello/:name', respond
server.head '/hello/:name', respond

#console.log process.env
clientResource = epilogue.resource
  model: sql.models.client
  endpoints: ['/api/dev/sunny/clients', '/api/dev/sunny/clients/:id']




sql.sync()
  .then ->
    server.listen PORT, HOST, -> 
      console.log "Server running on #{HOST}:#{PORT}."
  
