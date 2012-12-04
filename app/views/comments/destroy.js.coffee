$comment = $("#<%= dom_id(@comment) %>")
$comment.fadeOut "slow", ->
  $comment.remove()
  if $('#comments-list .comment').length == 0
    $('#comments-list').append('<i class="muted">No Comments</i>')
