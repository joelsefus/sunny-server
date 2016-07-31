os = require 'os'
path = require 'path'

Sequelize = require 'sequelize'
epilogue = require 'epilogue'
restify = require 'restify'

env = process.env.NODE_ENV or 'development'
#config = require('./config')[env]

config_module = require './config'

PORT = process.env.NODE_PORT or 8081
HOST = process.env.NODE_IP or os.hostname()

db = require './models'
sql = db.sequelize

# init database object
#sql = new Sequelize
#  dialect: 'sqlite'
#  storage: 'sunny.sqlite'
#  omitNull: true

# import models
sql.import './models/client'
sql.import './models/document'








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
APIPATH = '/api/dev'

clientPath = "#{APIPATH}/sunny/clients"
clientResource = epilogue.resource
  model: sql.models.client
  endpoints: [clientPath, "#{clientPath}/:id"]

documentPath = "#{APIPATH}/sitedocuments"
documentResource = epilogue.resource
  model: sql.models.document
  endpoints: [documentPath, "#{documentPath}/:name"]


server.get /\/assets\/?.*/, restify.serveStatic
  directory: path.resolve __dirname, '..'

server.get /^\/build\//, restify.serveStatic
  directory: path.resolve __dirname, '..'

server.get /\/fonts\//, restify.serveStatic
  directory: path.resolve __dirname, '..'

server.get '/', (req, res, next) ->
  manifest = require '../build/manifest.json'
  theme = 'cornsilk'
  page = require './index'
  beautify = require('js-beautify').html
  #console.log "page", page manifest
  index = page manifest, theme
  index = beautify index
  res.writeHead 200,
    'Content-Length': Buffer.byteLength index
    'Content-Type': 'text/html'
  res.write index
  res.end()
  next()

sql.sync()
  .then ->
    server.listen PORT, HOST, -> 
      console.log "Server running on #{HOST}:#{PORT}."
  
