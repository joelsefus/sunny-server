Backbone = require 'backbone'
Marionette = require 'backbone.marionette'

AppTemplates = require '../templates'


MainChannel = Backbone.Radio.channel 'global'

ace = require 'brace'

beautify = require('js-beautify').html
require 'brace/mode/html'
require 'brace/mode/markdown'
require 'brace/theme/twilight'
require 'brace/theme/cobalt'


{ BaseKottiResourceFormView } = require './base'

class KottiResourceFormView extends BaseKottiResourceFormView

class NewDocumentView extends KottiResourceFormView
  template: AppTemplates.AceEditNodeForm
  editorTheme: 'ace/theme/twilight'
  editorMode: 'ace/mode/html'
  editorContainer: 'ace-editor'
  ui:
    editor: '#ace-editor'
  
  saveModel: ->
    callbacks =
      success: => @trigger 'save:form:success', @model
      error: => @trigger 'save:form:failure', @model
      patch: false
    @model.save @model.attributes, callbacks
    
  createModel: ->
    @model
    
  updateModel: ->
    data = @model.get('data') || {}
    atts = {}
    atts.title = @ui.title.val()
    atts.description = @ui.description.val()
    atts.body = @editor.getValue()
    data.attributes = atts
    data.type = @model.content_type
    # FIXME!!!!
    atts.tags = []
    @model.set "data", data
    # we set the id to trick backbone into
    # thinking that we are performing an update
    # instead of an insert, since jsonapi seems
    # to desire a PUT for this.
    @model.set "id", "please_put_me"
    
  onDomRefresh: () ->
    @editor = ace.edit @editorContainer
    @editor.setTheme @editorTheme
    session = @editor.getSession()
    session.setMode @editorMode
    super()
       

    
module.exports =
  NewDocumentView: NewDocumentView
