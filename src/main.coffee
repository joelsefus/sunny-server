os = require 'os'
path = require 'path'
http = require 'http'

express = require 'express'
gzipStatic = require 'connect-gzip-static'
# FIXME start using this
ensureLogin = require 'connect-ensure-login'

Middleware = require './middleware'
UserAuth = require './userauth'
ApiRoutes = require './apiroutes'
db = require './models'
pages = require './pages'

webpackManifest = require '../build/manifest.json'

sql = db.sequelize
UseMiddleware = false or process.env.__DEV__ is 'true'
PORT = process.env.NODE_PORT or 8081
HOST = process.env.NODE_IP or os.hostname()

# create express app
app = express()
auth = UserAuth.auth

#app.use express.favicon()

Middleware.setup app
UserAuth.setup app
ApiRoutes.setup app

  
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


app.get '/', pages.make_page 'index'
app.get '/sunny', auth, pages.make_page 'sunny'

admin_auth = (req, res, next) ->
  if req.isAuthenticated() and req.user.name == 'admin'
    next()
  else
    res.sendStatus(403)
    
app.get '/admin', auth, admin_auth, pages.make_page 'admin'
      


server = http.createServer app


sql.sync()
  .then ->
    server.listen PORT, HOST, -> 
      console.log "Server running on #{HOST}:#{PORT}."
  
