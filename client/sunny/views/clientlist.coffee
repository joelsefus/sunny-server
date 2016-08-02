Templates = require '../templates'
Views = require './base'

ClientItemTemplate = Templates.base_item_template 'client'
        
ClientListTemplate = Templates.base_list_template 'client'

class ClientItemView extends Views.BaseItemView
  template: ClientItemTemplate
  item_type: 'client'
  

  
class ClientListView extends Views.BaseListView
  childView: ClientItemView
  template: ClientListTemplate
  childViewContainer: '#client-container'
  item_type: 'client'
    
module.exports = ClientListView

