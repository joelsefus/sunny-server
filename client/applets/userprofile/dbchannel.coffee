$ = require 'jquery'
_ = require 'underscore'
Backbone = require 'backbone'
Marionette = require 'backbone.marionette'

{ BaseCollection } = require 'agate/src/collections'

{ User
  CurrentUser } = require 'agate/src/users'
  
MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'
UserProfileChannel = Backbone.Radio.channel 'userprofile'


UserProfileChannel.reply 'update-user-config', ->
  console.log 'update-user-config called'
  

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



class Yard extends Backbone.Model
  urlRoot: '/api/dev/sunny/yards'

class YardCollection extends Backbone.Collection
  model: Yard
  url: '/api/dev/sunny/yards'
  

sunny_yards = new YardCollection()
SunnyChannel.reply 'yard-collection', ->
  sunny_yards

  

if __DEV__
  window.sunny_yards = sunny_yards

SunnyChannel.reply 'new-yard', () ->
  #sunny_yards.create()
  new Yard
  
SunnyChannel.reply 'add-yard', (options) ->
  yard = sunny_yards.create()
  for key, value of options
    yard.set key, value
  sunny_yards.add yard
  yard.save()

SunnyChannel.reply 'get-yard', (id) ->
  model = sunny_yards.get id
  if model is undefined
    new Yard
      id: id
  else
    model




    
module.exports =
  ClientCollection: ClientCollection
  YardCollection: YardCollection
  

