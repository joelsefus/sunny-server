BootStrapAppRouter = require 'agate/src/bootstrap_router'

require './dbchannel'
Controller = require './controller'


MainChannel = Backbone.Radio.channel 'global'
SunnyChannel = Backbone.Radio.channel 'sunny'



class Router extends BootStrapAppRouter
  appRoutes:
    'sunny': 'list_clients'
    'sunny/clients': 'list_clients'
    'sunny/clients/new': 'new_client'
    'sunny/clients/edit/:id': 'edit_client'
    
MainChannel.reply 'applet:sunny:route', () ->
  controller = new Controller MainChannel
  SunnyChannel.reply 'main-controller', ->
    controller
  SunnyChannel.reply 'edit-client', (id) ->
    controller.edit_client id
  console.log controller
  router = new Router
    controller: controller
  if __DEV__
    window.scontroller = controller
  
