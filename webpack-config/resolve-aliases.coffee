# webpack config resolve.alias
path = require 'path'
nodeModulesPath = path.resolve __dirname, '..', 'node_modules'

phaserbuild = path.resolve nodeModulesPath, 'phaser/build/custom'
phaser = path.resolve phaserbuild, 'phaser-split.js'
pixi = path.resolve phaserbuild, 'pixi.js'
p2 = path.resolve phaserbuild, 'p2.js'


module.exports =
  jquery: 'jquery/src/jquery'
  'bootstrap-fileinput-css': 'bootstrap-fileinput/css/fileinput.min.css'
  'bootstrap-fileinput-js': 'bootstrap-fileinput/js/fileinput.min.js'
  tablednd: 'TableDnD/js/jquery.tablednd.js'
  request: 'browser-request'
  'tag-it': 'tag-it/js/tag-it.js'
  'radio-shim': path.join __dirname, 'radio-shim.coffee'
  common: path.join __dirname, '../coffee/common'
  # FIXME: this should be resolved otherwise
  # 'backbone': path.resolve(nodeModulesPath, 'backbone.marionette', 'node_modules', 'backbone')
  #backbone: path.resolve nodeModulesPath, 'backbone.marionette', 'node_modules', 'backbone'
  #backbone: 'backbone.marionette/node_modules/backbone/backbone.js'
  #underscore: 'backbone.marionette/node_modules/underscore/underscore.js'
  #underscore: 'lodash'
  #underscore: path.resolve nodeModulesPath, 'backbone.marionette', 'node_modules', 'underscore'
  phaser: phaser
  pixi: pixi
  p2: p2
  
