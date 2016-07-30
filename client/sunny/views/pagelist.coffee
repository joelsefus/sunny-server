Backbone = require 'backbone'
Marionette = require 'backbone.marionette'
tc = require 'teacup'

{ navigate_to_url } = require 'agate/src/apputil'
{ show_modal } = require 'agate/src/regions'
{ modal_close_button } = require 'agate/src/templates/buttons'

MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'

ConfirmDeleteTemplate = tc.renderable (model) ->
  tc.div '.modal-dialog', ->
    tc.div '.modal-content', ->
      tc.h3 "Do you really want to delete #{model.name}?"
      tc.div '.modal-body', ->
        tc.div '#selected-children'
      tc.div '.modal-footer', ->
        tc.ul '.list-inline', ->
          btnclass = 'btn.btn-default.btn-sm'
          tc.li "#confirm-delete-button", ->
            modal_close_button 'OK', 'check'
          tc.li "#cancel-delete-button", ->
            modal_close_button 'Cancel'
    


ClientItemTemplate = tc.renderable (model) ->
  item_btn = ".btn.btn-default.btn-xs"
  tc.li ".list-group-item.client-item", ->
    tc.span ->
      tc.a href:"#client/view/#{model.name}", model.name
      tc.div '.btn-group.pull-right', ->
        tc.button ".edit-client.#{item_btn}.btn-info.fa.fa-edit", 'edit'
        tc.button ".delete-client.#{item_btn}.btn-danger.fa.fa-close", 'delete'
        
ClientListTemplate = tc.renderable () ->
  tc.button '#new-client.btn.btn-default', ->
    "Add New Client"
  tc.hr()
  tc.ul "#client-container.list-group"




class ConfirmDeleteModal extends Backbone.Marionette.ItemView
  template: ConfirmDeleteTemplate
  ui:
    confirm_delete: '#confirm-delete-button'
    cancel_button: '#cancel-delete-button'
    
  events: ->
    'click @ui.confirm_delete': 'confirm_delete'

  confirm_delete: ->
    name = @model.get 'name'
    response = @model.destroy()
    response.done =>
      MessageChannel.request 'success', "#{name} deleted.",
    response.fail =>
      MessageChannel.request 'danger', "#{name} NOT deleted."
      
    
class ClientItemView extends Backbone.Marionette.ItemView
  template: ClientItemTemplate
  ui:
    edit_client: '.edit-client'
    delete_client: '.delete-client'
    client_item: '.client-item'
    
  events: ->
    'click @ui.edit_client': 'edit_client'
    'click @ui.delete_client': 'delete_client'
    
  edit_client: ->
    navigate_to_url "#sunny/clients/edit/#{@model.id}"
    
  delete_client: ->
    console.log "delete_client", @model
    view = new ConfirmDeleteModal
      model: @model
    console.log 'modal view', view
    show_modal view, true

  
class ClientListView extends Backbone.Marionette.CompositeView
  childView: ClientItemView
  template: ClientListTemplate
  childViewContainer: '#client-container'
  ui:
    make_new_client: '#new-client'
    
  events: ->
    'click @ui.make_new_client': 'make_new_client'

  _show_modal: (view, backdrop=false) ->
    modal_region = MainChannel.request 'main:app:get-region', 'modal'
    modal_region.backdrop = backdrop
    modal_region.show view

  
  make_new_client: ->
    navigate_to_url '#sunny/clients/new'
    
  

module.exports = ClientListView

