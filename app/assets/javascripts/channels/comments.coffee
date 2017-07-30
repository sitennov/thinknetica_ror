$ ->
  if gon.question_id
    App.comments = App.cable.subscriptions.create "CommentsChannel",
      connected: ->
        @perform 'follow', question_id: gon.question_id

      received: (data) ->
        comment = $.parseJSON(data)
        $('.' + comment.commentable_type.toLowerCase() + '-comments .comments-list').append(JST["templates/comment"](comment))
  else
    if (App.comments)
      App.cable.subscriptions.remove(App.comments)
