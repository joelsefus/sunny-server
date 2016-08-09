Backbone = require 'backbone'
Marionette = require 'backbone.marionette'
tc = require 'teacup'

{ navigate_to_url } = require 'agate/src/apputil'

Templates = require '../templates'
Views = require './base'

view_template = tc.renderable (model) ->
  tc.div '.row.listview-list-entry', ->
    tc.span "Name: #{model.name}"
    tc.br()
    tc.span "Full Name: #{model.fullname}"
    tc.br()
    tc.span "Description"
    tc.br()
    tc.div model.description
    tc.span ".glyphicon.glyphicon-grain"
  tc.div '.row', ->
    tc.div '.listview-header', ->
      tc.span 'Yards'
      tc.button '#add-yard-btn.btn.btn-default.btn-xs.pull-right', 'Add Yard'
    
class MainView extends Backbone.Marionette.ItemView
  template: view_template
  ui:
    addyard: '#add-yard-btn'
  events: ->
    'click @ui.addyard': 'add_yard'

  add_yard: ->
    navigate_to_url "#sunny/clients/addyard/#{@model.id}"
    
    
    
module.exports = MainView

