Backbone = require 'backbone'
Marionette = require 'backbone.marionette'
tc = require 'teacup'

MainChannel = Backbone.Radio.channel 'global'

class UserMainView extends Backbone.Marionette.ItemView
  pass
  

class FrontDoorMainView extends Backbone.Marionette.ItemView
  template: FDTemplates.DefaultStaticDocumentTemplate

module.exports =
  FrontDoorMainView: FrontDoorMainView

