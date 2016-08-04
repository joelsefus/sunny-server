var APIPATH, db, epilogue, setup, sql;

epilogue = require('epilogue');

db = require('./models');

sql = db.sequelize;

APIPATH = '/api/dev';

setup = function(app) {
  var clientPath, clientResource, documentPath, documentResource, yardPath, yardResource;
  epilogue.initialize({
    app: app,
    sequelize: sql
  });
  app.get(APIPATH + "/current-user", function(req, res, next) {
    var user;
    user = null;
    if (req != null ? req.user : void 0) {
      user = req.user;
    }
    return res.json(user);
  });
  clientPath = APIPATH + "/sunny/clients";
  clientResource = epilogue.resource({
    model: sql.models.client,
    endpoints: [clientPath, clientPath + "/:id"]
  });
  yardPath = APIPATH + "/sunny/yards";
  yardResource = epilogue.resource({
    model: sql.models.yard,
    endpoints: [yardPath, yardPath + "/:id"]
  });
  documentPath = APIPATH + "/sitedocuments";
  return documentResource = epilogue.resource({
    model: sql.models.document,
    endpoints: [documentPath, documentPath + "/:name"]
  });
};

module.exports = {
  setup: setup
};
