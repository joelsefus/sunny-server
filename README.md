# Sunny

## Instructions

nodejs global packages:

- coffee-script

- webpack

- webpack-dev-server

- bower

- gulp


Clone the repository:

```git clone https://github.com/umeboshi2/sunny-server.git```

Install npm dependencies:

```
cd sunny-server
npm install
```

### CSS

To use compass to build the css, type: ```bundle install```

### Development

Use webpack-dev-server to bundle and serve the client:

```webpack-dev-server --config webpack.config.coffee```

Then use another terminal to run the web server, and 
reload automatically on file changes:

```gulp watch```

You can use the app by opening a brouser to http://$(hostname):8080.

