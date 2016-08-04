

bodyParser = require 'body-parser'
cookieParser = require 'cookie-parser'
expressSession = require 'express-session'
morgan = require 'morgan'
httpsRedirect = require 'express-https-redirect'


setup = (app) ->
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

    
  
module.exports =
  setup: setup
  
