Templates = require '../templates'
Views = require './base'

    



YardItemTemplate = Templates.base_item_template 'yard'
        
YardListTemplate = Templates.base_list_template 'yard'

class YardItemView extends Views.BaseItemView
  template: YardItemTemplate
  item_type: 'yard'
  
class YardListView extends Views.BaseListView
  childView: YardItemView
  template: YardListTemplate
  childViewContainer: '#yard-container'
  item_type: 'yard'
  

module.exports = YardListView

