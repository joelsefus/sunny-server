Backbone = require 'backbone'
Marionette = require 'backbone.marionette'

{ MainController } = require 'agate/src/controllers'
{ login_form } = require 'agate/src/templates/forms'

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
      MessageChannel.request 'danger', 'Failed to get document'
      
    
  frontdoor: ->
    user = MainChannel.request 'current-user'
    if not user.has 'name'
      view = new Backbone.Marionette.ItemView
        template: login_form
      @_show_content view
    else
      @view_page 'intro'

module.exports = Controller

