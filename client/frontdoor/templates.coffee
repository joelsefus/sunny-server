tc = require 'teacup'
marked = require 'marked'


########################################
# Templates
########################################
DefaultViewTemplate = tc.renderable (doc) ->
  #atts = doc.data.attributes
  tc.article '.document-view.content', ->
    tc.h1 doc.title
    #tc.p '.lead', atts.description
    tc.div '.body', ->
      content = doc.content
      if doc.doctype is 'markdown'
        content = marked content
      tc.raw content

DefaultStaticDocumentTemplate = tc.renderable (doc) ->
  #atts = doc.data.attributes
  tc.article '.document-view.content', ->
    tc.div '.body', ->
      tc.raw marked doc.content

module.exports =
  DefaultViewTemplate: DefaultViewTemplate
  DefaultStaticDocumentTemplate: DefaultStaticDocumentTemplate
