tc = require 'teacup'
marked = require 'marked'

{ navbar_collapse_button
  dropdown_toggle
  frontdoor_url
  editor_url } = require 'agate/src/templates/common'

{ workflow_dropdown } = require 'agate/src/templates/editorbar'

# Main Templates must use teacup.
# The template must be a teacup.renderable, 
# and accept a layout model as an argument.

########################################
# Templates
########################################
frontdoor_main = tc.renderable (content) ->
  tc.raw content.data.attributes.body
  #tc.div 'hello there'
  #
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

FolderViewTemplate = tc.renderable (doc) ->
  atts = doc.data.attributes
  relmeta = doc.data.relationships.meta
  tc.article '.document-view.content', ->
    tc.h1 atts.title
    tc.p '.lead', atts.description
    #tc.div tags
    # FIXME i18n
    tc.h2 'Contents'
    tc.div '.body', ->
      tc.table '.table.table-condensed', ->
        tc.thead ->
          tc.tr ->
            # FIXME I18N
            tc.th 'Title'
            tc.th 'Type'
            tc.th 'Creation Date'
            tc.th 'Modification Date'
        tc.tbody ->
          for child in relmeta.children
            type_info = child.data.relationships.meta.type_info
            href = frontdoor_url(child.path)
            tc.tr ->
              tc.td ->
                tc.a href:href, child.data.attributes.title
              tc.td ->
                tc.a href:href, type_info.title
              tc.td ->
                tc.a href:href, child.meta.creation_date
              tc.td ->
                tc.a href:href, child.meta.modification_date


DefaultStaticDocumentTemplate = tc.renderable (doc) ->
  #atts = doc.data.attributes
  tc.article '.document-view.content', ->
    tc.div '.body', ->
      tc.raw marked doc.content

module.exports =
  frontdoor_main: frontdoor_main
  DefaultViewTemplate: DefaultViewTemplate
  FolderViewTemplate: FolderViewTemplate
  DefaultStaticDocumentTemplate: DefaultStaticDocumentTemplate
