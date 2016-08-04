passport = require 'passport'
Strategy = require('passport-local').Strategy
bcrypt = require 'bcrypt'

db = require './models'
sql = db.sequelize

passport.use new Strategy (username, password, done) ->
  sql.models.user.findOne
    where:
      name: username
  .then (user) ->
    if !user
      done null, false
      return
    result = bcrypt.compareSync password, user.password
    
    bcrypt.compare password, user.password, (err, res) ->
      if res
        done null, user
      else
        done null, false
    ##if user.password != password
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



auth = (req, res, next) ->
  if req.isAuthenticated()
    next()
  else
    res.redirect '/'
    
setup = (app) ->
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

module.exports =
  setup: setup
  auth: auth
  
