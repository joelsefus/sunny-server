{ start_with_user } = require './base'
Marionette = require 'backbone.marionette'
prepare_app = require 'agate/src/app-prepare'

AppModel = require './base-appmodel'
AppModel.set 'applets',
  [
    {
      name: 'Clients'
      url: '/sunny'
    }
    {
      appname: 'bumblr'
      name: 'Bumblr'
      url: '#bumblr'
    }
  ]
brand = AppModel.get 'brand'
brand.url = '#'
AppModel.set brand: brand
  
MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'
DocChannel = Backbone.Radio.channel 'static-documents'


# use a signal to request appmodel
MainChannel.reply 'main:app:appmodel', ->
  AppModel

######################
# require applets
require '../applets/frontdoor/main'
require '../applets/userprofile/main'
require '../applets/bumblr/main'

app = new Marionette.Application()

prepare_app app, AppModel

if __DEV__
  # DEBUG attach app to window
  window.App = app

# start the app
start_with_user app


module.exports = app


