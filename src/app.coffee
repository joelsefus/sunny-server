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

UseMiddleware = false or process.env.__DEV__ is 'true'

sql.models.user.findOrCreate
  where:
    name: 'admin'
  defaults:
    password: 'admin'
.then (user, created) ->
  return
  

passport.use new Strategy (username, password, done) ->
  sql.models.user.findOne
    where:
      name: username
  .then (user) ->
    if !user
      done null, false
      return
    if user.password != password
      done null, false
      return
    done null, user
    return
    
passport.serializeUser (user, done) ->
  done null, user.id

passport.deserializeUser (id, done) ->
  sql.models.user.findById id
  .then (user) ->
    done null, user
  
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
  res.redirect '/'
  return

app.post '/login', passport.authenticate('local', failureRedirect: '/'), (req, res) ->
  res.redirect '/'

app.get '/logout', (req, res) ->
  req.logout()
  res.redirect '/'
  return
  

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
    #publicPath: config.output.publicPath
    # FIXME using abosule path?
    publicPath: '/build/'
    stats:
      colors: true
  console.log "Using webpack middleware"
else
  app.use '/build', gzipStatic(path.join __dirname, '../build')


app.get '/', (req, res, next) ->
  #if req?.user
  #  console.log "there is a session user.", req.user
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

app.get "#{APIPATH}/current-user", (req, res, next) ->
  user = null
  if req?.user
    user = req.user
  res.json user

clientPath = "#{APIPATH}/sunny/clients"
clientResource = epilogue.resource
  model: sql.models.client
  endpoints: [clientPath, "#{clientPath}/:id"]

documentPath = "#{APIPATH}/sitedocuments"
documentResource = epilogue.resource
  model: sql.models.document
  endpoints: [documentPath, "#{documentPath}/:name"]


app.get "#{APIPATH}/node-docs", (req, res, next) ->
  res.json(APIPATH)
  

server = http.createServer app


sql.sync()
  .then ->
    server.listen PORT, HOST, -> 
      console.log "Server running on #{HOST}:#{PORT}."
  
