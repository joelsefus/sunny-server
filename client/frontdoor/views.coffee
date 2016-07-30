Backbone = require 'backbone'
Marionette = require 'backbone.marionette'

FDTemplates = require './templates'


{ remove_trailing_slashes
  make_json_post } = require 'agate/src/apputil'

#require 'jquery-ui'

MainChannel = Backbone.Radio.channel 'global'

class FrontDoorMainView extends Backbone.Marionette.ItemView
  template: FDTemplates.DefaultStaticDocumentTemplate

module.exports =
  FrontDoorMainView: FrontDoorMainView

