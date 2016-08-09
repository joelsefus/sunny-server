Templates = require 'agate/src/templates/basecrud'

Views = require 'agate/src/basecrudviews'

ClientItemTemplate = Templates.base_item_template 'client', 'sunny'
        
ClientListTemplate = Templates.base_list_template 'client'

class ClientItemView extends Views.BaseItemView
  route_name: 'sunny'
  template: ClientItemTemplate
  item_type: 'client'
  

  
class ClientListView extends Views.BaseListView
  route_name: 'sunny'
  childView: ClientItemView
  template: ClientListTemplate
  childViewContainer: '#client-container'
  item_type: 'client'
    
module.exports = ClientListView

