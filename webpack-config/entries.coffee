# webpack config module.entry
vendor = require './vendor'

module.exports =
  # FIXME: we probably want vendor.js for multipage sites
  #vendor: vendor
  app: './client/application.coffee'

  
