{ MainController } = require 'agate/src/controllers'


MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'
ResourceChannel = Backbone.Radio.channel 'resources'


CONTENT_TYPES =
  html: 'Document'
  markdown: 'MarkDownDocument'

CONTENT_LOOKUP =
  Document: 'html'
  MarkDownDocument: 'markdown'


class Controller extends MainController
  _get_doc_and_render_view: (viewclass) ->
    @_make_editbar()
    view = new viewclass
      model: @root_doc
    @_show_content view
    
  list_pages: () ->
    console.log "List Pages"
    require.ensure [], () =>
      PageListView = require './views/pagelist'
      view = new PageListView
        collection: ResourceChannel.request 'app-documents'
      @_show_content view
    # name the chunk
    , 'listpages'

  edit_page: (name) ->
    #console.log "CONTROLLER: edit_page", name
    require.ensure [], () =>
      { EditPageView } = require './views/editor'
      @_show_content new EditPageView
        model: ResourceChannel.request 'get-document', name
    # name the chunk
    , 'edit-page'
      
  new_page: () ->
    #console.log "CONTROLLER: make new page (nameless)"
    require.ensure [], () =>
      { NewPageView } = require './views/editor'
      @_show_content new NewPageView
    # name the chunk
    , 'new-page'
      
      
module.exports = Controller

