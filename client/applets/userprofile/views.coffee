Backbone = require 'backbone'
Marionette = require 'backbone.marionette'
tc = require 'teacup'

MainChannel = Backbone.Radio.channel 'global'

user_profile_template = tc.renderable (model) ->
  tc.div ->
    tc.span "User Name: #{model.name}"
    tc.br()
    tc.span "Config: #{model.config}"

class UserMainView extends Backbone.Marionette.ItemView
  template: usermainview
  


module.exports =
  UserMainView: UserMainView

