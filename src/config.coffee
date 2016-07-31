module.exports =
  development:
    dialect: 'sqlite'
    storage: './sunny.sqlite'
    omitNull: true
  production:
    dialect: 'sqlite'
    # trailing slash on OPENSHIFT_DATA_DIR
    storage: "#{process.env.OPENSHIFT_DATA_DIR}sunny.sqlite"
    omitNull: true
