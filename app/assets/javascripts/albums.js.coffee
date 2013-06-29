getNumColumns = (itemWidth, $window) ->
  $window.width()
  Math.floor($window.width() / itemWidth)

setupMasonry = ->
  $imagesContainer = $('#images')
  $window = $(window)
  # width + margin + border + box-shadow
  itemWidth = 305

  $imagesContainer.masonry
    itemSelector: '.grid-item'
    isResizable: true

  $imagesContainer.imagesLoaded ->
    $imagesContainer.masonry()

  imagesLoadedCount = 0
  $imagesContainer.find('img').load ->
    if getNumColumns(itemWidth, $window) <= imagesLoadedCount += 1
      imageLoadedCount = 0
      $imagesContainer.masonry()

  $window.resize ->
    numColumns = getNumColumns(itemWidth, $window)

    containerWidth = itemWidth * numColumns
    containerWidth = 945 if numColumns <= 3

    if $window.width() <= containerWidth + 25
      containerWidth = itemWidth * (numColumns - 1)

    $imagesContainer.width(containerWidth)
    $imagesContainer.masonry()

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
