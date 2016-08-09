# webpack config module.entry
vendor = require './vendor'

client_entry = (name) ->
  "./client/entries/#{name}.coffee"

pages = [
  'index'
  'sunny'
  'admin'
  ]

entries =
  vendor: vendor

for page in pages
  entries[page] = client_entry page

module.exports = entries
