$ ->
  $answers = $('.answers')
  if gon.question_id
    App.answers = App.cable.subscriptions.create "AnswersChannel",
      connected: ->
        @perform 'follow', question_id: gon.question_id

      received: (data) ->
        answer = $.parseJSON(data)
        $answers.append JST["templates/answer"](answer)
  else
    if (App.answers)
      App.cable.subscriptions.remove(App.answers)
