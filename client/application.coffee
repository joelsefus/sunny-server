$ = require 'jquery'
Backbone = require 'backbone'
Marionette = require 'backbone.marionette'
require 'radio-shim'
  
require 'bootstrap'

#Models = require './models'

Views = require 'agate/src/views'
AppModel = require './appmodel'

require 'agate/src/users'
require 'agate/src/clipboard'
require 'agate/src/messages'
require './static-documents'

{ BootstrapModalRegion } = require 'agate/src/regions'

prepare_app = require 'agate/src/app-prepare'
initialize_page = require 'agate/src/app-initpage'

MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'
DocChannel = Backbone.Radio.channel 'static-documents'


if __DEV__
  console.warn "__DEV__", __DEV__, "DEBUG", DEBUG
  Backbone.Radio.DEBUG = true
  #FIXME
  window.dchnnl = DocChannel


######################
# start app setup

# use a signal to request appmodel
MainChannel.reply 'main:app:appmodel', ->
  AppModel


MainChannel.reply 'mainpage:init', (appmodel) ->
  # get the app object
  app = MainChannel.request 'main:app:object'
  # initialize the main view
  initialize_page app
  # emit the main view is ready
  MainChannel.trigger 'mainpage:displayed'


MainChannel.on 'appregion:navbar:displayed', ->
  # this handler is useful if there are views that need to be
  # added to the navbar.  The navbar should have regions to attach
  # the views
  # --- example ---
  # view = new view
  # aregion = MainChannel.request 'main:app:get-region', aregion
  # aregion.show view
  if __DEV__ and DEBUG
    console.warn "__DEV__ navbar displayed"
  # current user should already be fetched before
  # any view is shown
  user = MainChannel.request 'current-user'
  console.log "USER IS", user
  show_view = (user) ->
    view = new Views.UserMenuView
      model: user
    usermenu = MainChannel.request 'main:app:get-region', 'usermenu'
    usermenu.show view
  if not user.has 'name'
    response = user.fetch()
    console.log "Fetching user", response
    response.done =>
      console.log "User is here", user
      show_view user
    response.fail =>
      MessageChannel.request 'danger', 'Get user failed'
  else
    show_view user
    
# require applets
# Applets need to be loaded to provide
# urls for the app routers
# 
# FIXME - how to get this to work?
#for applet in AppModel.get 'applets'
#  require "#{applet.appname}/main"


require './frontdoor/main'
require './sunny/main'
require './dbdocs/main'


app = new Marionette.Application()

prepare_app app, AppModel

if __DEV__
  # DEBUG attach app to window
  window.App = app
  

# Start the Application
# make sure current user is fetched from server before starting app
user = MainChannel.request 'current-user'
response = user.fetch()
response.done =>
  app.start()
response.fail =>
  console.log "bad things have happened"
  

module.exports = app


