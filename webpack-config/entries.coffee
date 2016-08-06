# webpack config module.entry
vendor = require './vendor'

module.exports =
  vendor: vendor
  index: './client/entries/index.coffee'
  sunny: './client/entries/sunny.coffee'

  
