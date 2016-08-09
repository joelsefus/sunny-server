$ = require 'jquery'
Backbone = require 'backbone'

Util = require 'agate/src/apputil'
{ MainController } = require 'agate/src/controllers'

Models = require './models'
Collections = require './collections'

MiscViews = require './views/misc'
SideBarView = require './views/sidebar'


BumblrChannel = Backbone.Radio.channel 'bumblr'

side_bar_data = new Backbone.Model
  entries: [
    {
      name: 'List Blogs'
      url: '#bumblr/listblogs'
    }
    {
      name: 'Settings'
      url: '#bumblr/settings'
    }
    ]

class Controller extends MainController
  sidebarclass: SideBarView
  sidebar_model: side_bar_data
  
  set_header: (title) ->
    header = $ '#header'
    header.text title
    
  start: ->
    content = @_get_region 'content'
    sidebar = @_get_region 'sidebar'
    if content.hasView()
      console.log 'empty content....'
      content.empty()
    if sidebar.hasView()
      console.log 'empty sidebar....'
      sidebar.empty()
    @set_header 'Bumblr'
    @list_blogs()
    
  show_mainview: () ->
    @_make_sidebar()
    view = new MiscViews.MainBumblrView
    @_show_content view
    Util.scroll_top_fast()
    
  show_dashboard: () ->
    @_make_sidebar()
    view = new MiscViews.BumblrDashboardView
    @_show_content view
    Util.scroll_top_fast()
      
  list_blogs: () ->
    #console.log 'list_blogs called;'
    @_make_sidebar()
    require.ensure [], () =>
      console.log "sidebar created"
      blogs = BumblrChannel.request 'get_local_blogs'
      console.log 'blogs', blogs
      SimpleBlogListView = require './views/bloglist'
      view = new SimpleBlogListView
        collection: blogs
      @_show_content view
    # name the chunk
    , 'bumblr-views'
    
  view_blog: (blog_id) ->
    #console.log 'view blog called for ' + blog_id
    @_make_sidebar()
    require.ensure [], () =>
      host = blog_id + '.tumblr.com'
      collection = BumblrChannel.request 'make_blog_post_collection', host
      BlogPostListView = require './views/postlist'
      response = collection.fetch()
      response.done =>
        view = new BlogPostListView
          collection: collection
        @_show_content view
        Util.scroll_top_fast()
    # name the chunk
    , 'bumblr-views'
    
  add_new_blog: () ->
    #console.log 'add_new_blog called'
    @_make_sidebar()
    require.ensure [], () =>
      NewBlogFormView = require './views/newblog'
      view = new NewBlogFormView
      @_show_content view
      Util.scroll_top_fast()
    # name the chunk
    , 'bumblr-views'
    
          
  settings_page: () ->
    #console.log 'Settings page.....'
    @_make_sidebar()
    require.ensure [], () =>
      ConsumerKeyFormView = require './views/settingsform'
      settings = BumblrChannel.request 'get_app_settings'
      view = new ConsumerKeyFormView model:settings
      @_show_content view
      Util.scroll_top_fast()
    # name the chunk
    , 'bumblr-views'
    
module.exports = Controller

