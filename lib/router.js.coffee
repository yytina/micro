Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  waitOn: -> 
    [Meteor.subscribe('notifications')]
  

PostsListController = RouteController.extend
  template: 'postsList',
  increment: 5, 
  postsLimit: ->
    parseInt(@.params.postsLimit) || @.increment

  findOptions: ->
    {limit: @.postsLimit()}

  waitOn: ->
    Meteor.subscribe('posts', @.findOptions())

  data: ->
    {posts: Posts.find({}, @.findOptions())}


Router.map ->
  @.route 'postsList', 
    path: '/:postsLimit?'
    controller: PostsListController
  
  @.route 'postPage',
    path: '/posts/:_id'
    data: ->
      Session.set('currentPostId', @.params._id)
      Posts.findOne @.params._id
    waitOn: ->
      Meteor.subscribe('comments', @.params._id)
 

  @.route 'postEdit',
    path: '/posts/:_id/edit'
    data: -> Posts.findOne this.params._id
    
  @.route 'postSubmit', path: '/submit'

requireLogin = ->
  if ! Meteor.user()
    if Meteor.loggingIn()
      @.render @.loadingTemplate
    else
      @.render 'accessDenied'
    @.stop()

Router.before requireLogin, only: 'postSubmit'
Router.before -> clearErrors()