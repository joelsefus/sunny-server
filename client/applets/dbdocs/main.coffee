BootStrapAppRouter = require 'agate/src/bootstrap_router'

Controller = require './controller'

require './dbchannel'

MainChannel = Backbone.Radio.channel 'global'
ResourceChannel = Backbone.Radio.channel 'resources'



class Router extends BootStrapAppRouter
  empty_sidebar_on_route: true
  appRoutes:
    'dbdocs': 'list_pages'
    'dbdocs/newpage': 'new_page'
    'dbdocs/edit/:name': 'edit_page'
    
MainChannel.reply 'applet:dbdocs:route', () ->
  controller = new Controller MainChannel
  router = new Router
    controller: controller

