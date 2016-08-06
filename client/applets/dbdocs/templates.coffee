tc = require 'teacup'
marked = require 'marked'


{ navbar_collapse_button
  dropdown_toggle
  modal_close_button } = require 'agate/src/templates/buttons'
  
{ form_group_input_div } = require 'agate/src/templates/forms'

{ capitalize } = require 'agate/src/apputil'

########################################
# Templates
########################################

_edit_form = tc.renderable (doc) ->
  for field in ['name', 'title', 'description']
    form_group_input_div
      input_id: "input_#{field}"
      label: capitalize field
      input_attributes:
        name: field
        placeholder: field
        value: doc[field]
      value: doc.title
  tc.div '.form-group', ->
    tc.label '.control-label',
      for: 'select_doctype'
      "Doc Type"
    tc.select '.form-control', name:'select_doctype', ->
      for opt in ['html', 'markdown']
        if doc.doctype is opt
          tc.option selected:null, value:opt, opt
        else
          tc.option value:opt, opt
    
HalloEditNodeForm = tc.renderable (doc) ->
  _edit_form doc
  tc.div '#document-body', ->
    tc.raw doc.data.attributes.body
  tc.input '.btn.btn-default', type:'submit', value:"Update #{doc.data.type}"

AceEditNodeForm = tc.renderable (doc) ->
  _edit_form doc
  tc.div '#ace-editor', style:'position:relative;width:100%;height:40em;'
  tc.input '.btn.btn-default', type:'submit', value:"Update #{doc.data.type}"

PageItem = tc.renderable (page) ->
  item_btn = ".btn.btn-default.btn-xs"
  tc.li ".page-item.list-group-item.row", ->
    tc.div '.col-md-3.pull-left', ->
      tc.a href:"#dbdocs/view/#{page.name}", page.name
    tc.div '.col-md-1.pull-right.button-group', ->
      tc.button ".edit-page.#{item_btn}.btn-primary.fa.fa-edit"
      tc.button ".delete-page.#{item_btn}.btn-danger.fa.fa-close"

PageList = tc.renderable () ->
  tc.button '#makenewpage.btn.btn-default', ->
    "new page"
  tc.hr()
  tc.ul "#pagecontainer.list-group"


ConfirmPageDeleteModal = tc.renderable (page) ->
  tc.div '.modal-dialog', ->
    tc.div '.modal-content', ->
      tc.h3 "Do you really want to delete #{page.name}?"
      tc.div '.modal-body', ->
        tc.div '#selected-children'
      tc.div '.modal-footer', ->
        tc.ul '.list-inline', ->
          btnclass = 'btn.btn-default.btn-sm'
          tc.li "#confirm-delete-button", ->
            modal_close_button 'OK', 'check'
          tc.li "#cancel-delete-button", ->
            modal_close_button 'Cancel'
    
NewPageForm = tc.renderable (doc) ->
  _edit_form doc
  tc.div '#ace-editor', style:'position:relative;width:100%;height:40em;'
  tc.input '.btn.btn-default', type:'submit', value:"Add #{doc.doctype}"
  tc.div '.spinner.fa.fa-spinner.fa-spin'
  

module.exports =
  AceEditNodeForm: AceEditNodeForm
  PageItem: PageItem
  PageList: PageList
  ConfirmPageDeleteModal: ConfirmPageDeleteModal
  NewPageForm: NewPageForm
