epilogue = require 'epilogue'

db = require './models'
sql = db.sequelize

APIPATH = '/api/dev'

setup = (app) ->
  epilogue.initialize
    app: app
    sequelize: sql



  app.get "#{APIPATH}/current-user", (req, res, next) ->
    user = null
    if req?.user
      user = req.user
    res.json user

  clientPath = "#{APIPATH}/sunny/clients"
  clientResource = epilogue.resource
    model: sql.models.client
    endpoints: [clientPath, "#{clientPath}/:id"]

  yardPath = "#{APIPATH}/sunny/yards"
  yardResource = epilogue.resource
    model: sql.models.yard
    endpoints: [yardPath, "#{yardPath}/:id"]

  documentPath = "#{APIPATH}/sitedocuments"
  documentResource = epilogue.resource
    model: sql.models.document
    endpoints: [documentPath, "#{documentPath}/:name"]


module.exports =
  setup: setup
  
