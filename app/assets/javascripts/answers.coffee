ready = ->
  $ ->
    answersList = $(".answers")

    $('.edit-answer-link').click (e) ->
      e.preventDefault();
      $(this).hide();
      answer_id = $(this).data('answerId')
      $('form#edit-answer-' + answer_id).show();

    App.cable.subscriptions.create('AnswersChannel', {
      connected: ->
        console.log 'Connected!'
        @perform 'follow'
      ,

      received: (data) ->
        answersList.append data
    })

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
