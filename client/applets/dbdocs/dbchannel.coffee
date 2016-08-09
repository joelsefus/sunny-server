Backbone = require 'backbone'

{ BaseCollection } = require 'agate/src/collections'
{ make_dbchannel } = require 'agate/src/basecrudchannel'

ResourceChannel = Backbone.Radio.channel 'resources'

apipath = "/api/dev/sitedocuments"

class Document extends Backbone.Model
  urlRoot: apipath
  defaults:
    name: ''
    # doctype is either markdown or html
    doctype: 'markdown'
    title: ''
    content: ''
    description: ''
  
class DocumentCollection extends BaseCollection
  url: apipath
  model: Document

make_dbchannel ResourceChannel, 'document', Document, DocumentCollection

module.exports =
  DocumentCollection: DocumentCollection

