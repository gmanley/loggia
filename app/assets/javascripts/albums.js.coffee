$ ->
  $('.page-header h3').editable window.location.pathname,
    method: 'PUT'
    indicator: 'Saving...'
    tooltip: 'Click to edit...'
    ajaxoptions:
      dataType: 'json'
    submitdata: (value, settings) ->
      authenticity_token: authenticity_token
      _soshigal_session: session_token
      album:
        title: value

  $('li.active a, li.disabled a').on('click', false)

  $('textarea.expand')
    .focus ->
      $(this).height('75px')
      $('#new_comment .btn').show()
    .blur ->
      if $(this).val().length is 0
        $(this).height('25px')
        $('#new_comment .btn').hide()