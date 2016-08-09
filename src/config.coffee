module.exports =
  development:
    apipath: '/api/dev'
    dialect: 'sqlite'
    storage: './sunny.sqlite'
    omitNull: true
  production:
    apipath: '/api/dev'
    dialect: 'sqlite'
    # trailing slash on OPENSHIFT_DATA_DIR
    storage: "#{process.env.OPENSHIFT_DATA_DIR}sunny.sqlite"
    omitNull: true
