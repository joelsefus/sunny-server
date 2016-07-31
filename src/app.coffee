os = require 'os'
path = require 'path'
http = require 'http'

Sequelize = require 'sequelize'
epilogue = require 'epilogue'
express = require 'express'
bodyParser = require 'body-parser'
cookieParser = require 'cookie-parser'
expressSession = require 'express-session'
morgan = require 'morgan'
gzipStatic = require 'connect-gzip-static'

passport = require 'passport'
Strategy = require('passport-local').Strategy
ensureLogin = require 'connect-ensure-login'

PORT = process.env.NODE_PORT or 8081
HOST = process.env.NODE_IP or os.hostname()

db = require './models'
sql = db.sequelize

# import models
sql.import './models/user'
sql.import './models/client'
sql.import './models/document'

UseMiddleware = false and process.env.__DEV__ is 'true'


passport.use new Strategy (username, password, cb) ->
  sql.models.user.findOne
    where:
      name: username
  .then (user) ->
    if !user
      cb null, false
    if user.password != password
      cb null, user

passport.serializeUser (user, cb) ->
  cb null, user.id

passport.deserializeUser (id, cb) ->
  umodel = db.models.user.findById id, (err, user) ->
    if err
      cb(err)
    cb null, user

# create express app
app = express()

# logging
app.use morgan 'combined'

# parsing
app.use cookieParser()
app.use bodyParser.json()
app.use bodyParser.urlencoded({ extended: false })

# session handling
app.use expressSession
  secret: 'please set me from outside config'
  resave: false
  saveUninitialized: false

app.use passport.initialize()
app.use passport.session()

app.get '/login', (req, res) ->
  return

app.post '/login', passport.authenticate('local', failureRedirect: '/login'), (req, res) ->
  res.redirect '/'

app.get '/logout', (req, res) ->
  req.logout()
  res.redirect '/'

app.get '/current/user', (req, res) ->
  res.json req.user
  

# health url required for openshift
app.get '/health', (req, res, next) ->
  res.end()

app.use '/assets', express.static(path.join __dirname, '../assets')
if UseMiddleware
  require 'coffee-script/register'
  webpack = require 'webpack'
  middleware = require 'webpack-dev-middleware'
  config = require '../webpack.config'
  compiler = webpack config
  app.use middleware compiler,
    publicPath: config.output.publicPath
    stats:
      colors: true
  console.log "Soon to use webpack middleware"
else
  #app.use '/build', express.static(path.join __dirname, '../build')
  app.use '/build', gzipStatic(path.join __dirname, '../build')


app.get '/', (req, res, next) ->
  if UseMiddleware
    manifest = {'app.js':'app.js'}
  else
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


server = http.createServer app


sql.sync()
  .then ->
    server.listen PORT, HOST, -> 
      console.log "Server running on #{HOST}:#{PORT}."
  
