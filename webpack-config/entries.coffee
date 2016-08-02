# webpack config module.entry
vendor = require './vendor'

module.exports =
  # FIXME: we probably want vendor.js for multipage sites
  vendor: vendor
  index: './client/application.coffee'
  sunny: './client/sunny-app.coffee'

  
