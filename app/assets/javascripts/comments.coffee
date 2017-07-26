$ ->
  $(document).on 'click', '.question .add-comment', (e) ->
    e.preventDefault()
    $(this).hide()
    $('.question .new_comment').show()
