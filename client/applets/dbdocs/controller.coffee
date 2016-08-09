{ MainController } = require 'agate/src/controllers'


MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'
ResourceChannel = Backbone.Radio.channel 'resources'

class Controller extends MainController
  list_pages: () ->
    console.log "List Pages"
    require.ensure [], () =>
      PageListView = require './views/pagelist'
      view = new PageListView
        collection: ResourceChannel.request 'document-collection'
      @_show_content view
    # name the chunk
    , 'dbdocs-views'

  edit_page: (name) ->
    require.ensure [], () =>
      { EditPageView } = require './views/editor'
      @_show_content new EditPageView
        model: ResourceChannel.request 'get-document', name
    # name the chunk
    , 'dbdocs-views'
      
  new_page: () ->
    require.ensure [], () =>
      { NewPageView } = require './views/editor'
      @_show_content new NewPageView
    # name the chunk
    , 'dbdocs-views'
      
      
module.exports = Controller

