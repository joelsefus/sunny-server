module.exports = function(sequelize, DataTypes) {
  return sequelize.define('document', {
    name: {
      type: DataTypes.STRING,
      unique: true
    },
    title: DataTypes.STRING,
    description: DataTypes.TEXT,
    doctype: DataTypes.STRING,
    content: DataTypes.TEXT
  });
};
