var UseMiddleware, beautify, make_page, make_page_header, make_page_html, pages, webpackManifest, write_page;

beautify = require('js-beautify').html;

pages = require('./templates');

webpackManifest = require('../../build/manifest.json');

UseMiddleware = false || process.env.__DEV__ === 'true';

make_page_html = function(name, theme) {
  var filename, manifest, page;
  if (UseMiddleware) {
    manifest = {
      'vendor.js': 'vendor.js'
    };
    filename = name + ".js";
    manifest[filename] = filename;
  } else {
    manifest = webpackManifest;
  }
  page = pages[name](manifest, theme);
  return beautify(page);
};

make_page_header = function(res, page) {
  return res.writeHead(200, {
    'Content-Length': Buffer.byteLength(page),
    'Content-Type': 'text/html'
  });
};

write_page = function(page, res, next) {
  make_page_header(res, page);
  res.write(page);
  res.end();
  return next();
};

make_page = function(name) {
  return function(req, res, next) {
    var config, page, theme;
    theme = 'custom';
    if (req.isAuthenticated()) {
      config = req.user.config;
      theme = config.theme;
    }
    page = make_page_html(name, theme);
    return write_page(page, res, next);
  };
};

module.exports = {
  make_page: make_page
};
