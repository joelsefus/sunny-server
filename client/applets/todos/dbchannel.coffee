Backbone = require 'backbone'

{ BaseCollection } = require 'agate/src/collections'
{ make_dbchannel } = require 'agate/src/basecrudchannel'

TodoChannel = Backbone.Radio.channel 'todos'

url = '/api/dev/todos'
class Todo extends Backbone.Model
  urlRoot: url

class TodoCollection extends Backbone.Collection
  url: url
  model: Todo


todo_collection = new TodoCollection()

make_dbchannel TodoChannel, 'todo', Todo, TodoCollection

if __DEV__
  window.todo_collection = todo_collection

module.exports =
  TodoCollection: TodoCollection
