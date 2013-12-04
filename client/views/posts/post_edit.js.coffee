Template.postEdit.helpers
  post: -> Posts.findOne Session.get( 'currentPostId' )

Template.postEdit.events
  'submit form': (e) ->
    e.preventDefault()

    currentPostId = Session.get 'currentPostId'

    postProperties =
      url: $(e.target).find('[name=url]').val()
      title: $(e.target).find('[name=title]').val()

    Posts.update currentPostId, $set: postProperties, (error) ->
      if error
        # display the error to the user
        alert error.reason
      else
        Router.go 'postPage',  _id: currentPostId

  'click .delete': (e) ->
    e.preventDefault()

    if  confirm("Delete this post?")
      currentPostId = Session.get 'currentPostId'
      Posts.remove currentPostId
      Router.go 'postsList'