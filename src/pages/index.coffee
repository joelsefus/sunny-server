beautify = require('js-beautify').html

pages = require './templates'
webpackManifest = require '../../build/manifest.json'

# FIXME require this
UseMiddleware = false or process.env.__DEV__ is 'true'

make_page_html = (name, theme) ->
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

make_page = (name) ->
  (req, res, next) ->
    # FIXME make a site config
    theme = 'custom'
    if req.isAuthenticated()
      config = req.user.config
      theme = config.theme
    page = make_page_html name, theme
    write_page page, res, next
  
module.exports =
  make_page: make_page
