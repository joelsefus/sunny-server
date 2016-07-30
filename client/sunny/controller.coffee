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
    if __DEV__
      console.log "List Clients"
    require.ensure [], () =>
      ListView = require './views/pagelist'
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
    if __DEV__
      console.log "ayayayaNew Clients"
    require.ensure [], () =>
      { NewClientView } = require './views/editor'
      @_show_content new NewClientView
    # name the chunk
    , 'sunny-new-client'
      

      
  edit_client: (id) ->
    if __DEV__
      console.log "Edit Client"
    require.ensure [], () =>
      { EditClientView } = require './views/editor'
      clients = SunnyChannel.request 'client-collection'
      model = clients.get id
      if model is undefined
        console.log 'model not in collection'
        model = SunnyChannel.request 'get-client', id
      console.log '@clients, model', @clients, model
      response = model.fetch()
      response.done =>
        window.edclient = model
        view = new EditClientView
          model: model
        window.edview = view
        @_show_content view
    # name the chunk
    , 'sunny-edit-client'
      
      
module.exports = Controller

