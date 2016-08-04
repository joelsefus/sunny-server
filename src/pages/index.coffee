beautify = require('js-beautify').html

pages = require './templates'
webpackManifest = require '../../build/manifest.json'

# FIXME require this
UseMiddleware = false or process.env.__DEV__ is 'true'

make_page = (name, theme) ->
  if UseMiddleware
    manifest = {'vendor.js':'vendor.js'}
    filename = "#{name}.js"
    manifest[filename] = filename
  else
    manifest = webpackManifest
  page = pages[name] manifest, theme
  beautify page

make_page_header = (res, page) ->
  res.writeHead 200,
    'Content-Length': Buffer.byteLength page
    'Content-Type': 'text/html'
  
write_page = (page, res, next) ->
  make_page_header res, page
  res.write page
  res.end()
  next()      

  
module.exports =
  make_page: make_page
  write_page: write_page
