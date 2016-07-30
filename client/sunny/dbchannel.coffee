$ = require 'jquery'
_ = require 'underscore'
Backbone = require 'backbone'
Marionette = require 'backbone.marionette'

{ BaseCollection } = require 'agate/src/collections'

MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'
SunnyChannel = Backbone.Radio.channel 'sunny'

class BaseModel extends Backbone.Model
  parse: (response) ->
    if response.result is 'success' 
      return response.data
    else
      MessageChannel.request 'display-message', "Failed to parse model", 'danger'
      

class BasicClient extends BaseModel
  url: ->
    "/api/sunny-dev/sunny/clients/#{@id}"


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
  new Client
    id: id
  
module.exports =
  ClientCollection: ClientCollection
  

