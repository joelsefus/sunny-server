Util = require 'agate/src/apputil'

{ MainController } = require 'agate/src/controllers'


MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'
TodoChannel = Backbone.Radio.channel 'todos'

class Controller extends MainController
  collection: TodoChannel.request 'todo-collection'
  
  list_todos: () ->
    require.ensure [], () =>
      ListView = require './views/todolist'
      view = new ListView
        collection: @collection
      response = @collection.fetch()
      response.done =>
        @_show_content view
      response.fail =>
        MessageChannel.request 'danger', "Failed to load todos."
    # name the chunk
    , 'todos-list-todos'

  new_todo: () ->
    require.ensure [], () =>
      { NewView } = require './views/editor'
      @_show_content new NewView
    # name the chunk
    , 'todos-new-todo'

  edit_todo: (id) ->
    require.ensure [], () =>
      { EditView } = require './views/editor'
      model = TodoChannel.request 'get-todo', id
      @_load_view EditView, model, 'todo'
    # name the chunk
    , 'todos-edit-todo'
      
  view_todo: (id) ->
    require.ensure [], () =>
      MainView = require './views/viewtodo'
      model = TodoChannel.request 'get-todo', id
      @_load_view MainView, model, 'todo'
    # name the chunk
    , 'todos-view-todo'
      
      
module.exports = Controller

