setupInfiniteScroll = ->
  $imagesContainer = $('#images')
  $.waypoints('destroy')
  $paginationContainer = $('.pagination')
  if $paginationContainer.exists
    $paginationContainer.hide()
    $imagesContainer.waypoint 'infinite',
      items: '.image'
      more: '.pagination .next a'
      onBeforePageLoad: ->
        App.LoadingIndicator.show()
      onAfterPageLoad: ($newImages) ->
        $newImages.hide().imagesLoaded ->
          $newImages.fadeIn()
          $imagesContainer.masonry('appended', $newImages)
          App.LoadingIndicator.hide()
          $.waypoints('refresh')
          $('.pagination').hide()

setupMasonry = ->
  $container = $('.grid-container').masonry
    itemSelector: '.grid-item'
    transitionDuration: '0.5s'
    isFitWidth: true
    gutter: 15

  $container.imagesLoaded ->
    $container.masonry()
    setupInfiniteScroll()

# Fixes an issue where masonry images overlap after hitting the back button.
document.addEventListener 'page:restore', ->
  setupMasonry()

$ ->
  setupMasonry()

  $('.datepicker').datepicker(format: 'yyyy.mm.dd')

  $('#clear-images-filter').on 'click', (e) ->
    $('#album_source_ids').val([]).trigger('liszt:updated')
    e.preventDefault()

  $('#filter-images').on('show hide', ->
    $(this).prev().find('.accordian-toggle i')
           .toggleClass('icon-chevron-down')
           .toggleClass('icon-chevron-up')
  ).on('shown', -> $(this).toggleClass('collapse'))
