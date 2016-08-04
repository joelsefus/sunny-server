Util = require 'agate/src/apputil'

{ MainController } = require 'agate/src/controllers'


MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'
SunnyChannel = Backbone.Radio.channel 'sunny'


class Controller extends MainController
  _get_doc_and_render_view: (viewclass) ->
    @_make_editbar()
    view = new viewclass
      model: @root_doc
    @_show_content view

  clients: SunnyChannel.request 'client-collection'
  
  list_clients: () ->
    require.ensure [], () =>
      ListView = require './views/clientlist'
      view = new ListView
        collection: @clients
      response = @clients.fetch()
      response.done =>
        @_show_content view
      response.fail =>
        MessageChannel.request 'danger', "Failed to load clients."
    # name the chunk
    , 'sunny-list-clients'

  new_client: () ->
    require.ensure [], () =>
      { NewClientView } = require './views/clienteditor'
      @_show_content new NewClientView
    # name the chunk
    , 'sunny-new-client'
      
  add_yard: (client_id) ->
    require.ensure [], () =>
      { NewYardView } = require './views/yardeditor'
      @_show_content new NewYardView
    # name the chunk
    , 'sunny-add-yard'
      

  _show_edit_client: (vclass, model) ->
    view = new vclass
      model: model
    @_show_content view
    
  edit_client: (id) ->
    require.ensure [], () =>
      { EditClientView } = require './views/clienteditor'
      model = SunnyChannel.request 'get-client', id
      if model.has 'name'
        @_show_edit_client EditClientView, model
      else
        response = model.fetch()
        response.done =>
          @_show_edit_client EditClientView, model
        response.fail =>
          MessageChannel.request 'danger', "Failed to load client data."
    # name the chunk
    , 'sunny-edit-client'
      
      
  view_client: (id) ->
    require.ensure [], () =>
      ClientMainView = require './views/viewclient'
      model = SunnyChannel.request 'get-client', id
      if model.has 'name'
        @_show_edit_client ClientMainView, model
      else
        response = model.fetch()
        response.done =>
          @_show_edit_client ClientMainView, model
        response.fail =>
          MessageChannel.request 'danger', "Failed to load client data."
    # name the chunk
    , 'sunny-view-client'
      
      
module.exports = Controller

