_ = require 'underscore'
Backbone = require 'backbone'

#beautify = require('js-beautify').html

BootstrapFormView = require 'agate/src/bootstrap_formview'

{ capitalize
  navigate_to_url
  make_field_input_ui } = require 'agate/src/apputil'

tc = require 'teacup'
{ form_group_input_div } = require 'agate/src/templates/forms'

MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'
TodoChannel = Backbone.Radio.channel 'todos'

_edit_form = tc.renderable (model) ->
  for field in ['name']
    form_group_input_div
      input_id: "input_#{field}"
      label: capitalize field
      input_attributes:
        name: field
        placeholder: field
        value: model[field]
  field = 'description'
  form_group_input_div
    input_id: "input_#{field}"
    input_type: 'textarea'
    label: capitalize field
    input_attributes:
      name: field
      placeholder: field
    content: model[field]
    
form_template = tc.renderable (model) ->
  _edit_form model
  tc.input '.btn.btn-default', type:'submit', value:"Submit"
  tc.div '.spinner.fa.fa-spinner.fa-spin'
  


class BaseEditor extends BootstrapFormView
  template: form_template
  fieldList: ['name']
  ui: ->
    uiobject = make_field_input_ui @fieldList
    _.extend uiobject, {'description': 'textarea[name="description"]'}
    return uiobject
  
  updateModel: ->
    for field in @fieldList.concat ['description']
      console.log 'field', field, @ui[field].val()
      @model.set field, @ui[field].val()
    # update other fields
    
  onSuccess: (model) ->
    name = model.get 'name'
    MessageChannel.request 'success', "#{name} saved successfully.", "grain"
    navigate_to_url '#todos'
    
class NewView extends BaseEditor
  createModel: ->
    TodoChannel.request 'new-todo'

  saveModel: ->
    collection = TodoChannel.request 'todo-collection'
    collection.add @model
    super
    
class EditView extends BaseEditor
  # the model should be assigned in the controller
  createModel: ->
    #console.log "createModel called on EditPageView", @model
    @model
    
module.exports =
  NewView: NewView
  EditView: EditView
  

