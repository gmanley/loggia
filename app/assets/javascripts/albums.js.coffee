setupMasonry = ->
  $imagesContainer = $('.grid-container')
  $window = $(window)

  $imagesContainer.masonry
    itemSelector: '.grid-item'
    isResizable: true

  $imagesContainer.imagesLoaded ->
    $imagesContainer.masonry('reload')

  $imagesContainer.find('img').load ->
    $imagesContainer.masonry('reload')

  imageSize = 300

  $window.resize ->
    $window.width()
    columns = Math.floor($window.width() / imageSize)
    containerWidth = imageSize * columns - 15 + 40
    containerWidth = 940 if columns <= 3

    if $window.width() <= containerWidth + 25
      containerWidth = imageSize * (columns - 1) - 15 + 40

    $imagesContainer.width(containerWidth)
    $imagesContainer.masonry('reload')

  $window.resize()

# Fixes an issue where masonry images overlap after hitting the back button.
$(document).on 'page:restore', ->
  setupMasonry()

$ ->
  setupMasonry()

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

  $('#clear-images-filter').on 'click', (e) ->
    $('#album_source_ids').val([]).trigger('liszt:updated')
    e.preventDefault()

  $('#filter-images').on('show hide', ->
    $(this).prev().find('.accordian-toggle i')
           .toggleClass('icon-chevron-down')
           .toggleClass('icon-chevron-up')
  ).on('shown', -> $(this).toggleClass('collapse'))
