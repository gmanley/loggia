$ ->
  $newCommentBtn = $('#new_comment .btn').hide()
  $('textarea.expand')
    .focus ->
      $(this).height('75px')
      $newCommentBtn.show()
    .blur ->
      if $(this).val().length is 0
        $(this).height('25px')
        $newCommentBtn.hide()
