$ ->
  $('textarea.expand')
    .focus ->
      $(this).height('75px')
      $('#new_comment .btn').show()
    .blur ->
      if $(this).val().length is 0
        $(this).height('25px')
        $('#new_comment .btn').hide()