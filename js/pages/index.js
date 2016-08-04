var UseMiddleware, beautify, make_page, make_page_header, pages, webpackManifest, write_page;

beautify = require('js-beautify').html;

pages = require('./templates');

webpackManifest = require('../../build/manifest.json');

UseMiddleware = false || process.env.__DEV__ === 'true';

make_page = function(name, theme) {
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

module.exports = {
  make_page: make_page,
  write_page: write_page
};
