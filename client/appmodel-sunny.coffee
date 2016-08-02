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
      tc.div '#main-content.col-sm-9'
      tc.div '#sidebar.col-sm-3.right-column'
  tc.div '#footer'
  tc.div '#modal'

appmodel = new BaseAppModel
  hasUser: true
  brand:
    name: 'Sunny'
    url: '/'
  layout_template: layout_template
  container: 'container-fluid'
  #FIXME
  # applets listed here still need to be required in
  # application.coffee
  applets:
    [
      {
        appname: 'sunny'
        name: 'Sunny'
        url: '#sunny'
      }
      {
        appname: 'dbdocs'
        name: 'DB Docs'
        url: '#dbdocs'
      }
    ]
  regions: appregions

module.exports = appmodel
