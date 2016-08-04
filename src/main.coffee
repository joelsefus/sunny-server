os = require 'os'
path = require 'path'
http = require 'http'

express = require 'express'
gzipStatic = require 'connect-gzip-static'
# FIXME start using this
ensureLogin = require 'connect-ensure-login'

Middleware = require './middleware'
UserAuth = require './userauth'
auth = UserAuth.auth
ApiRoutes = require './apiroutes'
db = require './models'
pages = require './pages'
console.log 'pages', pages

webpackManifest = require '../build/manifest.json'

sql = db.sequelize
UseMiddleware = false or process.env.__DEV__ is 'true'
PORT = process.env.NODE_PORT or 8081
HOST = process.env.NODE_IP or os.hostname()

# create express app
app = express()

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

app.get '/', (req, res, next) ->
  theme = 'cornsilk'
  console.log 'pages-> ->', pages
  page = pages.make_page 'index', theme
  pages.write_page page, res, next

app.get '/sunny', auth, (req, res, next) ->
  theme = 'BlanchedAlmond'
  #theme = 'custom'
  page = pages.make_page 'sunny', theme
  pages.write_page page, res, next

server = http.createServer app


sql.sync()
  .then ->
    server.listen PORT, HOST, -> 
      console.log "Server running on #{HOST}:#{PORT}."
  
