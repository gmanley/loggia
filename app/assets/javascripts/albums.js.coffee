initMasonry = ($selector) ->
  $selector.masonry
    itemSelector: $selector.children('li')
    isFitWidth: true
    gutterWidth: 20

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

  $('.page-header h1').editable(window.location.pathname, editable_settings)

  $('li.active a, li.disabled a').on('click', false)

  $('#toggle_editing.inactive').on 'click', (e) ->
    $('.thumbnail').on 'click', (e) ->
      e.preventDefault()
      album_url = $(this).attr('href')
      $('.thumbnail-title').editable(album_url, editable_settings)
      $(this).children('.thumbnail-title').click()

  initMasonry($('#albums'))

  $container = $('#images')
  $container.imagesLoaded ->
    initMasonry($container)
