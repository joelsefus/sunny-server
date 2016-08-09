Backbone = require 'backbone'
Marionette = require 'backbone.marionette'

{ MainController } = require 'agate/src/controllers'
{ login_form } = require 'agate/src/templates/forms'

MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'
DocChannel = Backbone.Radio.channel 'static-documents'

class Controller extends MainController
  _view_resource: (doc) ->
    require.ensure [], () =>
      { FrontDoorMainView } = require './views'
      view = new FrontDoorMainView
        model: doc
      @_show_content view
    # name the chunk
    , 'frontdoor-main-view'
    
    
  view_page: (name) ->
    doc = DocChannel.request 'get-document', name
    response = doc.fetch()
    response.done =>
      @_view_resource doc
    response.fail =>
      MessageChannel.request 'danger', 'Failed to get document'
      

  frontdoor_needuser: ->
    user = MainChannel.request 'current-user'
    if user.has 'name'
      @frontdoor_hasuser user
    else
      @show_login()
      
  show_login: ->
    view = new Backbone.Marionette.ItemView
      template: login_form
    @_show_content view
    
  frontdoor_hasuser: (user) ->
    @default_view()

  default_view: ->
    @view_page 'intro'
      
  frontdoor: ->
    appmodel = MainChannel.request 'main:app:appmodel'
    if appmodel.get 'needUser'
      console.log 'needUser is true'
      @frontdoor_needuser()
    else
      @view_page 'intro'

module.exports = Controller

