# inspired by https://github.com/KyleAMathews/coffee-react-quickstart
# 
fs = require 'fs'

gulp = require 'gulp'
gutil = require 'gulp-util'

runSequence = require 'run-sequence'



size = require 'gulp-size'
coffee = require 'gulp-coffee'
nodemon = require 'gulp-nodemon'

tc = require 'teacup'

gulp.task 'coffee', () ->
  gulp.src('./src/**/*.coffee')
  .pipe coffee
    bare: true
  .on 'error', gutil.log
  .pipe size()
  .pipe gulp.dest './js'

gulp.task 'serve', () ->
  nodemon
    script: 'js/app.js'
    watch: 'js/**/*.js'
  
gulp.task 'indexhtml', (callback) ->
  manifest = require './build/manifest.json'
  theme = 'cornsilk'
  page = require './index'
  beautify = require('js-beautify').html
  #console.log "page", page manifest
  index = page manifest, theme
  fs.writeFileSync 'index.html', beautify index
  console.log "Created new index.html"

gulp.task 'indexdev', (callback) ->
  manifest = {'app.js':'app.js'}
  theme = 'cornsilk'
  page = require './index'
  beautify = require('js-beautify').html
  #console.log "page", page manifest
  index = page manifest, theme
  fs.writeFileSync 'index-dev.html', beautify index
  console.log "Created new index-dev.html"

gulp.task 'default', ->
  gulp.start 'coffee'
  
gulp.task 'watch', ['coffee', 'serve'], ->
  gulp.watch ['./src/**/*.coffee'], ['coffee']
  

gulp.task 'serveoirig', ->
  server = require './server'
  console.log 'server', server
  
