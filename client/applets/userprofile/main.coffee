BootStrapAppRouter = require 'agate/src/bootstrap_router'

require './dbchannel'
Controller = require './controller'


MainChannel = Backbone.Radio.channel 'global'

class Router extends BootStrapAppRouter
  appRoutes:
    'profile': 'show_profile'
    'profile/editconfig': 'edit_config'
    'profile/chpassword': 'change_password'
    
MainChannel.reply 'applet:userprofile:route', () ->
  controller = new Controller MainChannel
  router = new Router
    controller: controller
  
