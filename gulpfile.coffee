# inspired by https://github.com/KyleAMathews/coffee-react-quickstart
# 
fs = require 'fs'

gulp = require 'gulp'
gutil = require 'gulp-util'
size = require 'gulp-size'
compass = require 'gulp-compass'
coffee = require 'gulp-coffee'
nodemon = require 'gulp-nodemon'
#runSequence = require 'run-sequence'
concat = require 'gulp-concat'
uglify = require 'gulp-uglify'

webpack = require 'webpack'
tc = require 'teacup'

css_theme = 'cornsilk'

gulp.task 'compass', () ->
  gulp.src('./sass/*.scss')
  .pipe compass
    config_file: './config.rb'
    css: 'assets/stylesheets'
    sass: 'sass'
  .pipe size()
  .pipe gulp.dest 'assets/stylesheets'

gulp.task 'coffee', () ->
  gulp.src('./src/**/*.coffee')
  .pipe coffee
    bare: true
  .on 'error', gutil.log
  .pipe size
    showFiles: true
  .pipe uglify()
  .pipe size
    showFiles: true
  #.pipe concat 'main.js'
  #.pipe size()
  .pipe gulp.dest './js'

gulp.task 'serve', ['coffee'], () ->
  process.env.__DEV__ = 'true'
  nodemon
    script: 'js/main.js'
    watch: 'js/**/*.js'
  
gulp.task 'indexpage', (callback) ->
  manifest = {'app.js':'app.js'}
  theme = css_theme
  pages = require './src/pages'
  beautify = require('js-beautify').html
  #console.log "page", page manifest
  index = pages.index manifest, theme
  fs.writeFileSync 'index-dev.html', beautify index
  console.log "Created new index-dev.html"

gulp.task 'webpack:build-prod', ['compass'], (callback) ->
  # run webpack
  process.env.PRODUCTION_BUILD = 'true'
  ProdConfig = require './webpack.config'
  prodCompiler = webpack ProdConfig
  prodCompiler.run (err, stats) ->
    throw new gutil.PluginError('webpack:build-prod', err) if err
    gutil.log "[webpack:build-prod]", stats.toString(colors: true)
    callback()
    return
  return

gulp.task 'default', ->
  gulp.start 'coffee'
  
gulp.task 'watch', ['coffee', 'serve'], ->
  process.env.__DEV__ = 'true'
  gulp.watch ['./src/**/*.coffee'], ['coffee']
  

gulp.task 'production', ->
  gulp.start 'compass'
  gulp.start 'coffee'
  gulp.start 'webpack:build-prod'
