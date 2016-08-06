require './base'

#$ = require 'jquery'
#Backbone = require 'backbone'
Marionette = require 'backbone.marionette'
#require 'radio-shim'
  
#require 'bootstrap'

#Views = require 'agate/src/views'

AppModel = require './base-appmodel'

#require 'agate/src/users'
#require 'agate/src/clipboard'
#require 'agate/src/messages'
#require './static-documents'

prepare_app = require 'agate/src/app-prepare'

MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'
DocChannel = Backbone.Radio.channel 'static-documents'


# use a signal to request appmodel
MainChannel.reply 'main:app:appmodel', ->
  AppModel

######################
# require applets
require '../applets/frontdoor/main'

app = new Marionette.Application()

prepare_app app, AppModel

if __DEV__
  # DEBUG attach app to window
  window.App = app


# Start the Application
# make sure current user is fetched from server before starting app
user = MainChannel.request 'create-current-user-object', '/api/dev/current-user'
response = user.fetch()
response.done =>
  app.start()
response.fail =>
  MessageChannel.request 'danger', 'Get user failed'  

module.exports = app


