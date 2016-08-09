Backbone = require 'backbone'
Marionette = require 'backbone.marionette'
tc = require 'teacup'


BumblrChannel = Backbone.Radio.channel 'bumblr'

########################################
main_bumblr_view = tc.renderable (model) ->
  tc.p 'main bumblr view'

bumblr_dashboard_view = tc.renderable (model) ->
  tc.p 'bumblr_dashboard_view'


########################################
class MainBumblrView extends Backbone.Marionette.ItemView
  template: main_bumblr_view

class BumblrDashboardView extends Backbone.Marionette.ItemView
  template: bumblr_dashboard_view

module.exports =
  MainBumblrView: MainBumblrView
  BumblrDashboardView: BumblrDashboardView
