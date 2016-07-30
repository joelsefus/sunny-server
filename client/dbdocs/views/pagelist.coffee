Backbone = require 'backbone'
Marionette = require 'backbone.marionette'

AppTemplates = require '../templates'

# FIXME - these requires depend on fallback directive
# in webpack
{ navigate_to_url } = require 'agate/src/apputil'
{ show_modal } = require 'agate/src/regions'

MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'
ResourceChannel = Backbone.Radio.channel 'resources'

class DeletePageModal extends Backbone.Marionette.ItemView
  template: AppTemplates.ConfirmPageDeleteModal
  ui:
    confirm_delete: '#confirm-delete-button'
    cancel_button: '#cancel-delete-button'
    
  events: ->
    'click @ui.confirm_delete': 'confirm_delete'

  confirm_delete: ->
    name = @model.get 'name'
    #ResourceChannel.request 'delete-document', name
    response = @model.destroy()
    response.done =>
      MessageChannel.request 'display-message', "#{name} deleted.", 'success'
    response.fail =>
      MessageChannel.request 'display-message', "#{name} NOT deleted.", 'danger'
      
    
class PageItemView extends Backbone.Marionette.ItemView
  template: AppTemplates.PageItem
  ui:
    edit_page: '.edit-page'
    delete_page: '.delete-page'
    page_item: '.page-item'
    
  events: ->
    'click @ui.edit_page': 'edit_page'
    'click @ui.delete_page': 'delete_page'
    
  edit_page: ->
    pagename = @model.get 'name'
    navigate_to_url "#dbdocs/edit/#{pagename}"
    
  delete_page: ->
    console.log "delete_page", @model
    view = new DeletePageModal
      model: @model
    show_modal view, true

  
class PageListView extends Backbone.Marionette.CompositeView
  childView: PageItemView
  template: AppTemplates.PageList
  #childId: '#pagecontainer'
  childViewContainer: '#pagecontainer'
  ui:
    make_new_page: '#makenewpage'
    new_page_name: '#newpagename'
    
  events: ->
    'click @ui.make_new_page': 'make_new_page'

  _show_modal: (view, backdrop=false) ->
    modal_region = MainChannel.request 'main:app:get-region', 'modal'
    modal_region.backdrop = backdrop
    modal_region.show view

  
  make_new_page: ->
    pagename = @ui.new_page_name.val()
    navigate_to_url "#dbdocs/newpage"
    
  

module.exports = PageListView

