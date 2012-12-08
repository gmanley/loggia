$ ->
  editable_settings =
    method: 'PUT'
    indicator: 'Saving...'
    tooltip: 'Click to edit...'
    ajaxoptions:
      dataType: 'json'
    submitdata: (value, settings) ->
      album:
        title: value
    callback: (response, settings) ->
      $(this).html(response.title)

  $('.page-header h1 .album-title').editable(window.location.pathname, editable_settings)

  $('li.active a, li.disabled a').on('click', false)

  $('#toggle_editing.inactive').on 'click', (e) ->
    $('.thumbnail').on 'click', (e) ->
      $this = $(this)
      e.preventDefault()
      album_url = $this.attr('href')
      $('.thumbnail-title').editable(album_url, editable_settings)
      $this.children('.thumbnail-title').click()

  $('.datepicker').datepicker(format: 'yyyy.mm.dd')
