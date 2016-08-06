{ start_with_user } = require './base'
Marionette = require 'backbone.marionette'
prepare_app = require 'agate/src/app-prepare'

AppModel = require './base-appmodel'
AppModel.set 'applets',
  [
    {
      appname: 'sunny'
      name: 'Clients'
      url: '#sunny'
    }
    {
      appname: 'dbdocs'
      name: 'DB Docs'
      url: '#dbdocs'
    }
  ]


MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'


# use a signal to request appmodel
MainChannel.reply 'main:app:appmodel', ->
  AppModel

######################
# require applets
require '../applets/frontdoor/main'
require '../applets/sunny/main'
require '../applets/dbdocs/main'

app = new Marionette.Application()

prepare_app app, AppModel

if __DEV__
  # DEBUG attach app to window
  window.App = app


# Start the Application
start_with_user app

module.exports = app


