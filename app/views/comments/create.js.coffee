if $('#comments-list .comment').length == 0
  $('#comments-list').html('')

$('#comments-list').prepend("<%=j render(partial: 'comment', object: @comment) %>")
$('#comment_body').val('').trigger('blur')
