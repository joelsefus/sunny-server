BootStrapAppRouter = require 'agate/src/bootstrap_router'

require './dbchannel'
Controller = require './controller'


MainChannel = Backbone.Radio.channel 'global'

class Router extends BootStrapAppRouter
  appRoutes:
    'profile': 'show_profile'
    
MainChannel.reply 'applet:userprofiles:route', () ->
  controller = new Controller MainChannel
  router = new Router
    controller: controller
  
