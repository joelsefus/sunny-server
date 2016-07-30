{ MainController } = require 'agate/src/controllers'

MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'
DocChannel = Backbone.Radio.channel 'static-documents'

class Controller extends MainController
  _view_resource: (doc) ->
    @_make_editbar()
    require.ensure [], () =>
      { FrontDoorMainView } = require './views'
      view = new FrontDoorMainView
        model: doc
      @_show_content view
    # name the chunk
    , 'frontdoor-view-resource'
    
    
  view_page: (name) ->
    doc = DocChannel.request 'get-document', name
    response = doc.fetch()
    response.done =>
      @_view_resource doc
    response.fail =>
      MessageChannel.request 'display-message', 'Failed to get document', 'danger'
      
    
  frontdoor: ->
    @view_page 'intro'

module.exports = Controller

