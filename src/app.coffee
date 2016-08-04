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
httpsRedirect = require 'express-https-redirect'

passport = require 'passport'
Strategy = require('passport-local').Strategy
ensureLogin = require 'connect-ensure-login'
bcrypt = require 'bcrypt'

PORT = process.env.NODE_PORT or 8081
HOST = process.env.NODE_IP or os.hostname()

db = require './models'
pages = require './pages'
webpackManifest = require '../build/manifest.json'
beautify = require('js-beautify').html

sql = db.sequelize


UseMiddleware = false or process.env.__DEV__ is 'true'

passport.use new Strategy (username, password, done) ->
  sql.models.user.findOne
    where:
      name: username
  .then (user) ->
    if !user
      done null, false
      return
    bcrypt.compare password, user.password, (err, res) ->
      if res
        done null, user
      else
        done null, false
    ##if user.password != password
    #if bcrypt.user.password != password
    #  done null, false
    #  return
    #done null, user
    #return
    
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

# redirect to https
if '__DEV__' of process.env and process.env.__DEV__ is 'true'
  console.log 'skipping httpsRedirect'
else
  app.use '/', httpsRedirect()
  


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
  
auth = (req, res, next) ->
  if req.isAuthenticated()
    next()
  else
    res.redirect '/'
    
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

make_page = (name, theme) ->
  if UseMiddleware
    manifest = {'vendor.js':'vendor.js'}
    filename = "#{name}.js"
    manifest[filename] = filename
  else
    manifest = webpackManifest
  page = pages[name] manifest, theme
  beautify page

make_page_header = (res, page) ->
  res.writeHead 200,
    'Content-Length': Buffer.byteLength page
    'Content-Type': 'text/html'
  
write_page = (page, res, next) ->
  make_page_header res, page
  res.write page
  res.end()
  next()      

app.get '/', (req, res, next) ->
  theme = 'cornsilk'
  page = make_page 'index', theme
  write_page page, res, next

app.get '/sunny', auth, (req, res, next) ->
  theme = 'BlanchedAlmond'
  #theme = 'custom'
  page = make_page 'sunny', theme
  write_page page, res, next


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

yardPath = "#{APIPATH}/sunny/yards"
yardResource = epilogue.resource
  model: sql.models.yard
  endpoints: [yardPath, "#{yardPath}/:id"]

documentPath = "#{APIPATH}/sitedocuments"
documentResource = epilogue.resource
  model: sql.models.document
  endpoints: [documentPath, "#{documentPath}/:name"]



server = http.createServer app


sql.sync()
  .then ->
    server.listen PORT, HOST, -> 
      console.log "Server running on #{HOST}:#{PORT}."
  
