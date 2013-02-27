#= require libraries
#= require_tree .

$ ->
  $('.alert').delay(4000).fadeOut('slow')
  $('.chosen').chosen()
  $('.timeago').timeago()
