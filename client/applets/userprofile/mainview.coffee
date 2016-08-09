Backbone = require 'backbone'
Marionette = require 'backbone.marionette'
tc = require 'teacup'
{ navigate_to_url } = require 'agate/src/apputil'

MainChannel = Backbone.Radio.channel 'global'

user_profile_template = tc.renderable (model) ->
  tc.div ->
    tc.h2 "User Name: #{model.name}"
    tc.br()
    tc.h2 "Config:"
    tc.table ->
      for prop of model.config
        tc.tr ->
          tc.td ->
            tc.h3 prop
          tc.td ->
            tc.span model.config[prop]
    tc.br()
    tc.div '.button-group', ->
      tc.button '#edit-userconfig', 'Edit Config'
      tc.button '#change-password', 'Change Password'

    
class UserMainView extends Backbone.Marionette.ItemView
  template: user_profile_template
  ui:
    edit: '#edit-userconfig'
    chpass: '#change-password'
  
  events: ->
    'click @ui.edit': -> navigate_to_url '#profile/editconfig'
    'click @ui.chpass': -> navigate_to_url '#profile/chpassword'

    
  


module.exports = UserMainView

