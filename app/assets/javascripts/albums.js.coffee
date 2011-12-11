$ ->
  $('.page-header h3').editable window.location.pathname,
    method: 'PUT'
    indicator: 'Saving...'
    tooltip: 'Click to edit...'
    ajaxoptions:
      dataType: 'json'
    submitdata: (value, settings) ->
      "authenticity_token": authenticity_token
      "_soshigal_session": session_token
      album:
        title: value