Backbone = require 'backbone'
Marionette = require 'backbone.marionette'
tc = require 'teacup'

BootstrapFormView = require 'agate/src/bootstrap_formview'
{ capitalize
  navigate_to_url
  make_field_input_ui } = require 'agate/src/apputil'
{ form_group_input_div } = require 'agate/src/templates/forms'

MainChannel = Backbone.Radio.channel 'global'

# FIXME, make a css manifest
themes = [
  'cornsilk'
  'BlanchedAlmond'
  'DarkSeaGreen'
  'LavenderBlush'
  ]

chpass_form = tc.renderable () ->
  form_group_input_div
    input_id: 'input_oldpassword'
    label: 'Password'
    input_attributes:
      name: 'oldpassword'
      type: 'password'
      placeholder: 'Enter old password'
  form_group_input_div
    input_id: 'input_password'
    label: 'Password'
    input_attributes:
      name: 'password'
      type: 'password'
      placeholder: 'Enter new password'
  form_group_input_div
    input_id: 'input_confirm'
    label: 'Confirm Password'
    input_attributes:
      name: 'confirm'
      type: 'password'
      placeholder: 'Confirm your new password'
  tc.input '.btn.btn-default.btn-xs', type:'submit', value:"Change Password"
      

class ChangePasswordView extends BootstrapFormView
  template: chpass_form
  fieldList: ['oldpassword', 'password', 'confirm']
  ui: ->
    uiobject = make_field_input_ui @fieldList
    return uiobject
    
  createModel: ->
    @model
    
  updateModel: ->
    password = @ui.password.val()
    confirm = @ui.confirm.val()
    if password is confirm
      model = new Backbone.Model
        id: @model.id
      model.url = @model.url
      model.set 'password', password
    @model = model
    
  onSuccess: (model) ->
    navigate_to_url '#profile'


module.exports = ChangePasswordView

