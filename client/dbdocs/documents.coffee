$ = require 'jquery'
_ = require 'underscore'
Backbone = require 'backbone'
Marionette = require 'backbone.marionette'

{ BaseCollection } = require 'agate/src/collections'

MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'
ResourceChannel = Backbone.Radio.channel 'resources'

class Document extends Backbone.Model
  idAttribute: 'name'
  # FIXME, make apiroot configurable
  url: ->
    "/api/dev/sitedocuments/#{@attributes.name}"
  defaults:
    # name is pkey
    name: ''
    # doctype is either markdown or html
    doctype: 'markdown'
    title: ''
    content: ''
    description: ''
  

class DocumentCollection extends BaseCollection
  url: '/api/dev/sitedocuments'
  model: Document
  
app_documents = new DocumentCollection()
ResourceChannel.reply 'app-documents', ->
  app_documents
  

if __DEV__
  window.app_documents = app_documents

ResourceChannel.reply 'get-document', (name) ->
  app_documents.get name


ResourceChannel.reply 'new-document', ->
  new Document()

ResourceChannel.reply 'add-document', (name, title, description, content) ->
  docs = ResourceChannel.request 'app-documents'
  if __DEV__
    console.log "create document #{name}"
  doc = new Document()
    name: name
    title: title
    description: description
    content: content
    
  doc = make_new_doc name, title, content
  doc.save()
  app_documents.add doc
  doc
  
module.exports =
  DocumentCollection: DocumentCollection

