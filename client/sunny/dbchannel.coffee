$ = require 'jquery'
_ = require 'underscore'
Backbone = require 'backbone'
Marionette = require 'backbone.marionette'

{ BaseCollection } = require 'agate/src/collections'

MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'
SunnyChannel = Backbone.Radio.channel 'sunny'

class Client extends Backbone.Model
  urlRoot: '/api/dev/sunny/clients'

class ClientCollection extends Backbone.Collection
  model: Client
  url: '/api/dev/sunny/clients'
  

sunny_clients = new ClientCollection()
SunnyChannel.reply 'client-collection', ->
  sunny_clients

  

if __DEV__
  window.sunny_clients = sunny_clients

SunnyChannel.reply 'new-client', () ->
  #sunny_clients.create()
  new Client
  
SunnyChannel.reply 'add-client', (options) ->
  client = sunny_clients.create()
  for key, value of options
    client.set key, value
  sunny_clients.add client
  client.save()

SunnyChannel.reply 'get-client', (id) ->
  model = sunny_clients.get id
  if model is undefined
    new Client
      id: id
  else
    model
    
module.exports =
  ClientCollection: ClientCollection
  

