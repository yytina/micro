Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  waitOn: -> [
    Meteor.subscribe('posts')
    Meteor.subscribe('notifications')
  ]

Router.map ->
  @.route 'postsList', path: '/'
  
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