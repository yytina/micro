Template.notifications.helpers
  notifications: ->
    return Notifications.find {userId: Meteor.userId(), read: false}

  notificationCount: ->
      Notifications.find({userId: Meteor.userId(), read: false}).count()


Template.notification.helpers
  notificationPostPath: ->
    return Router.routes.postPage.path {_id: this.postId}


Template.notification.events
  'click a': ->
    Notifications.update this._id, {$set: {read: true}}
 