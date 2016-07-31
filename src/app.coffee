os = require 'os'
path = require 'path'
http = require 'http'

Sequelize = require 'sequelize'
epilogue = require 'epilogue'
express = require 'express'
bodyParser = require 'body-parser'


PORT = process.env.NODE_PORT or 8081
HOST = process.env.NODE_IP or os.hostname()

db = require './models'
sql = db.sequelize

# import models
sql.import './models/client'
sql.import './models/document'

app = express()
app.use bodyParser.json()
app.use bodyParser.urlencoded({ extended: false })

server = http.createServer app

#server = restify.createServer()

# health url required for openshift
app.get '/health', (req, res, next) ->
  res.end()

#server.use restify.queryParser()
#server.use restify.bodyParser()

#server.get /\/assets\/?.*/, restify.serveStatic
#  directory: path.resolve __dirname, '..'

#server.get /^\/build\//, restify.serveStatic
#  directory: path.resolve __dirname, '..'

#server.get /\/fonts\//, restify.serveStatic
#  directory: path.resolve __dirname, '..'

app.get '/', (req, res, next) ->
  manifest = require '../build/manifest.json'
  theme = 'cornsilk'
  page = require './index'
  beautify = require('js-beautify').html
  index = page manifest, theme
  index = beautify index
  res.writeHead 200,
    'Content-Length': Buffer.byteLength index
    'Content-Type': 'text/html'
  res.write index
  res.end()
  next()


epilogue.initialize
  app: app
  sequelize: sql


APIPATH = '/api/dev'

clientPath = "#{APIPATH}/sunny/clients"
clientResource = epilogue.resource
  model: sql.models.client
  endpoints: [clientPath, "#{clientPath}/:id"]

documentPath = "#{APIPATH}/sitedocuments"
documentResource = epilogue.resource
  model: sql.models.document
  endpoints: [documentPath, "#{documentPath}/:name"]


sql.sync()
  .then ->
    server.listen PORT, HOST, -> 
      console.log "Server running on #{HOST}:#{PORT}."
  
