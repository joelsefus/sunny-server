## Introduction

This is just another website.  There are many like it, but this one is Sunny.

[github](https://github.com/umeboshi2/sunny-server)


## NodeJS on Jessie

Add this line to ```/etc/apt/sources.list```:

```deb https://deb.nodesource.com/node_4.x/ jessie main```


Make sure the development user is in the ```staff``` group.

```
for dirname in /usr/bin /usr/lib/node_modules /usr/share/man/man1
do
sudo chgrp staff $dirname
sudo chmod g+ws $dirname
done
```

### Useful Global NPM Packages

- bower
- coffee-script
- electron-prebuilt
- express
- express-cli
- express-generator
- grunt-cli
- gulp
- http-server
- js2coffee
- karma-cli
- npm
- phantomjs-prebuilt
- webpack
- webpack-dev-server


