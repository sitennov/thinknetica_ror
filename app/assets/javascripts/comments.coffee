$ ->
  $(document).on 'click', '.question .add-comment', (e) ->
    e.preventDefault()
    $(this).hide()
    $('.question .new_comment').show()

  $(document).on 'click', '.answers .add-comment', (e) ->
    e.preventDefault()
    $(this).hide()
    $('.answer .new_comment').show()
