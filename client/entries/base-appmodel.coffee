$ = require 'jquery'
jQuery = require 'jquery'
_ = require 'underscore'
Backbone = require 'backbone'

{ BaseAppModel
  appregions } = require 'agate/src/appmodel'

tc = require 'teacup'

layout_template = tc.renderable () ->
  tc.div '#navbar-view-container'
  #tc.div '#editor-bar-container'
  tc.div ".container-fluid", ->
    tc.div '.row', ->
      tc.div '.col-sm-12', ->
        tc.div '#messages'
      tc.div '#sidebar.col-sm-3.left-column'
      tc.div '#main-content.col-sm-9'
  tc.div '#footer'
  tc.div '#modal'

appmodel = new BaseAppModel
  hasUser: true
  needUser: false
  brand:
    name: 'Sunny'
    url: '/'
  layout_template: layout_template
  container: 'container-fluid'
  regions: appregions

module.exports = appmodel
