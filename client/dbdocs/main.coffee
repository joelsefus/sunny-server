BootStrapAppRouter = require 'agate/src/bootstrap_router'

Controller = require './controller'

require './documents'

MainChannel = Backbone.Radio.channel 'global'
ResourceChannel = Backbone.Radio.channel 'resources'



class Router extends BootStrapAppRouter
  appRoutes:
    'dbdocs': 'list_pages'
    'dbdocs/newpage': 'new_page'
    'dbdocs/edit/:name': 'edit_page'
    
MainChannel.reply 'applet:dbdocs:route', () ->
  controller = new Controller MainChannel
  controller.root_doc = ResourceChannel.request 'get-document', 'startdoc'
  router = new Router
    controller: controller

