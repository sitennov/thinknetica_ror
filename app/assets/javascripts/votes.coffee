$ ->
  $(document).on 'ajax:success', '.votes', (e, data, status, xhr) ->
    item = $.parseJSON(xhr.responseText)
    element = "div#" + item.class
    $("#{element}-#{item.id} .vote-count").html(item.rating);
  .on 'ajax:error', '.votes', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $(element + '-' + item.id + '.vote-count').append(value)
