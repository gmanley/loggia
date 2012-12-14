if $('#comments-list .comment').length == 0
  $('#comments-list').html('')

$('#comments-list').prepend("<%=j render @comment %>")
$('#comment_body').val('').trigger('blur')
