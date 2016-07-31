module.exports = {
  development: {
    dialect: 'sqlite',
    storage: './sunny.sqlite',
    omitNull: true
  },
  production: {
    dialect: 'sqlite',
    storage: process.env.OPENSHIFT_DATA_DIR + "sunny.sqlite",
    omitNull: true
  }
};
