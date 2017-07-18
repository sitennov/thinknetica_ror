# # Place all the behaviors and hooks related to the matching controller here.
# # All this logic will automatically be available in application.js.
# # You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $ ->
    $('.votes').bind 'ajax:success', (e, data, status, xhr) ->
      item = $.parseJSON(xhr.responseText)
      element = "div#" + item.class
      $("#{element}-#{item.id} .vote-count").html(item.rating);
    .bind 'ajax:error', (e, xhr, status, error) ->
      errors = $.parseJSON(xhr.responseText)
      $.each errors, (index, value) ->
        $("#{element}-#{item.id} .vote-count").append(value)

$(document).on('turbolinks:load', ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
