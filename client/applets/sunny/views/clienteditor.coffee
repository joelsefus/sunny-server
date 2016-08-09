_ = require 'underscore'
Backbone = require 'backbone'

#beautify = require('js-beautify').html

BootstrapFormView = require 'agate/src/bootstrap_formview'

{ navigate_to_url
  make_field_input_ui } = require 'agate/src/apputil'

tc = require 'teacup'
{ make_field_input
  make_field_textarea } = require 'agate/src/templates/forms'

MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'
SunnyChannel = Backbone.Radio.channel 'sunny'

ClientForm = tc.renderable (model) ->
  tc.div '.listview-header', 'Client'
  for field in ['name', 'fullname']
    make_field_input(field)(model)
  make_field_textarea('description')(model)
  tc.input '.btn.btn-default', type:'submit', value:"Submit"
  tc.div '.spinner.fa.fa-spinner.fa-spin'
  


class BaseClientEditor extends BootstrapFormView
  fieldList: ['name', 'fullname']
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
    navigate_to_url '#sunny'
    

class NewClientView extends BaseClientEditor
  template: ClientForm
  createModel: ->
    SunnyChannel.request 'new-client'

  saveModel: ->
    clients = SunnyChannel.request 'client-collection'
    clients.add @model
    super
    
class EditClientView extends BaseClientEditor
  template: ClientForm

  # the model should be assigned in the controller
  createModel: ->
    @model
    
module.exports =
  NewClientView: NewClientView
  EditClientView: EditClientView
  

