var index, tc;

tc = require('teacup');

index = tc.renderable(function(manifest, theme) {
  tc.doctype();
  return tc.html({
    xmlns: 'http://www.w3.org/1999/xhtml'
  }, function() {
    tc.head(function() {
      tc.meta({
        charset: 'utf-8'
      });
      tc.link({
        rel: 'stylesheet',
        type: 'text/css',
        href: "assets/stylesheets/font-awesome.css"
      });
      return tc.link({
        rel: 'stylesheet',
        type: 'text/css',
        href: "assets/stylesheets/bootstrap-" + theme + ".css"
      });
    });
    return tc.body(function() {
      tc.div('.container-fluid', function() {
        return tc.div('.row', function() {
          tc.div('.col-sm-2');
          tc.div('.col-sm-6.jumbotron', function() {
            return tc.h1(function() {
              tc.text('Loading ...');
              return tc.i('.fa.fa-spinner.fa-spin');
            });
          });
          return tc.div('.col-sm-2');
        });
      });
      return tc.script({
        type: 'text/javascript',
        charset: 'utf-8',
        src: "build/" + manifest['app.js']
      });
    });
  });
});

module.exports = index;
