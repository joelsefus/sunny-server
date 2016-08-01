$ = require 'jquery'
_ = require 'underscore'
Backbone = require 'backbone'
Marionette = require 'backbone.marionette'

{ BaseCollection } = require 'agate/src/collections'

MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'
ResourceChannel = Backbone.Radio.channel 'resources'

apipath = "/api/dev/sitedocuments"

class Document extends Backbone.Model
  idAttribute: 'name'
  # FIXME, make apiroot configurable
  #url: ->
  #  "/api/dev/sitedocuments/#{@attributes.name}"
  urlRoot: apipath
  defaults:
    # name is pkey
    name: ''
    # doctype is either markdown or html
    doctype: 'markdown'
    title: ''
    content: ''
    description: ''
  

class DocumentCollection extends BaseCollection
  url: apipath
  model: Document
  
app_documents = new DocumentCollection()
ResourceChannel.reply 'app-documents', ->
  app_documents
  

if __DEV__
  window.app_documents = app_documents

ResourceChannel.reply 'get-document', (id) ->
  model = app_documents.get name
  if model is undefined
    new Document
      id: id
  else
    model


ResourceChannel.reply 'new-document', ->
  new Document

  
ResourceChannel.reply 'add-document', (name, title, description, content) ->
  docs = ResourceChannel.request 'app-documents'
  if __DEV__
    console.log "create document #{name}"
  new Document
  
module.exports =
  DocumentCollection: DocumentCollection

