tc = require 'teacup'
marked = require 'marked'


{ modal_close_button } = require 'agate/src/templates/buttons'
  
{ form_group_input_div } = require 'agate/src/templates/forms'



{ capitalize } = require 'agate/src/apputil'

# Main Templates must use teacup.
# The template must be a teacup.renderable, 
# and accept a layout model as an argument.

########################################
# Templates
########################################

base_item_template = (name) ->
  tc.renderable (model) ->
    item_btn = ".btn.btn-default.btn-xs"
    tc.li ".list-group-item.#{name}-item", ->
      tc.span ->
        tc.a href:"#sunny/#{name}s/view/#{model.id}", model.name
      tc.div '.btn-group.pull-right', ->
        tc.button ".edit-item.#{item_btn}.btn-info.fa.fa-edit", 'edit'
        tc.button ".delete-item.#{item_btn}.btn-danger.fa.fa-close", 'delete'

base_list_template = (name) ->
  tc.renderable (model) ->
    tc.div '.listview-header', ->
      tc.text capitalize name
    tc.button "#new-#{name}.btn.btn-default", ->
      "Add New #{capitalize name}"
    tc.hr()
    tc.ul "##{name}-container.list-group"


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
    

module.exports =
  base_item_template: base_item_template
  base_list_template: base_list_template
  ConfirmDeleteTemplate: ConfirmDeleteTemplate
  
