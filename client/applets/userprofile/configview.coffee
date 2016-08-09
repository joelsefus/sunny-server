Backbone = require 'backbone'
Marionette = require 'backbone.marionette'
tc = require 'teacup'

BootstrapFormView = require 'agate/src/bootstrap_formview'
{ capitalize
  navigate_to_url
  make_field_input_ui } = require 'agate/src/apputil'

MainChannel = Backbone.Radio.channel 'global'

# FIXME, make a css manifest
themes = [
  'cornsilk'
  'BlanchedAlmond'
  'DarkSeaGreen'
  'LavenderBlush'
  ]

config_template = tc.renderable (model) ->
  tc.div '.form-group', ->
    tc.label '.control-label',
      for: 'select_theme'
      "Theme"
    tc.select '.form-control', name:'select_theme', ->
      for opt in themes
        if model.config.theme is opt
          tc.option selected:null, value:opt, opt
        else
          tc.option value:opt, opt
  tc.input '.btn.btn-default', type:'submit', value:"Submit"
  tc.div '.spinner.fa.fa-spinner.fa-spin'

class UserConfigView extends BootstrapFormView
  template: config_template
  ui:
    theme: 'select[name="select_theme"]'
    
  createModel: ->
    @model
    
  updateModel: ->
    config = @model.get 'config'
    changed_config = false
    selected_theme = @ui.theme.val()
    if config.theme != selected_theme
      changed_config = true
      config.theme = selected_theme
    if changed_config
      @model.set 'config', config

  onSuccess: (model) ->
    navigate_to_url '#profile'
    

module.exports = UserConfigView

