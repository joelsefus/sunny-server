Backbone = require 'backbone'

{ BaseCollection } = require 'agate/src/collections'
{ make_dbchannel } = require 'agate/src/basecrudchannel'

SunnyChannel = Backbone.Radio.channel 'sunny'

url = '/api/dev/sunny/clients'
class Client extends Backbone.Model
  urlRoot: url

class ClientCollection extends Backbone.Collection
  model: Client
  url: url
  

make_dbchannel SunnyChannel, 'client', Client, ClientCollection
  
url = '/api/dev/sunny/yards'
class Yard extends Backbone.Model
  urlRoot: url

class YardCollection extends Backbone.Collection
  model: Yard
  url: url
  
make_dbchannel SunnyChannel, 'yard', Yard, YardCollection

module.exports =
  ClientCollection: ClientCollection
  YardCollection: YardCollection

