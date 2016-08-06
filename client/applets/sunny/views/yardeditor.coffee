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
SunnyChannel = Backbone.Radio.channel 'sunny'

_edit_form = tc.renderable (model) ->
  console.log "_edit_form", model
  for field in ['name']
    form_group_input_div
      input_id: "input_#{field}"
      label: capitalize field
      input_attributes:
        name: field
        placeholder: field
        value: model[field]
      value: model.title
  for field in ['description', 'jobdetails']
    form_group_input_div
      input_id: "input_#{field}"
      input_type: 'textarea'
      label: capitalize field
      input_attributes:
        name: field
        placeholder: field
      content: model[field]
    
YardForm = tc.renderable (model) ->
  tc.div '.listview-header', 'Yard'
  _edit_form model
  tc.input '.btn.btn-default', type:'submit', value:"Submit"
  tc.div '.spinner.fa.fa-spinner.fa-spin'
  


class BaseYardEditor extends BootstrapFormView
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
    MessageChannel.request 'display-message', "#{name} saved successfully.", "success"
    navigate_to_url '#sunny'
    

class NewYardView extends BaseYardEditor
  template: YardForm
  createModel: ->
    SunnyChannel.request 'new-yard'

  saveModel: ->
    callbacks =
      success: => @trigger 'save:form:success', @model
      error: => @trigger 'save:form:failure', @model
    yards = SunnyChannel.request 'yard-collection'
    yards.add @model
    super
    
class EditYardView extends BaseYardEditor
  template: YardForm

  # the model should be assigned in the controller
  createModel: ->
    #console.log "createModel called on EditPageView", @model
    @model
    
module.exports =
  NewYardView: NewYardView
  EditYardView: EditYardView
  

