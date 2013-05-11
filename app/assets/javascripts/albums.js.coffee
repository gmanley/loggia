setupMasonry = ->
  $container = $('.grid-container').masonry
    itemSelector: '.grid-item'
    transitionDuration: '0.5s'
    isFitWidth: true
    gutter: 15

  $container.imagesLoaded ->
    $container.masonry()

  $imagesContainer.infinitescroll
    navSelector: '.pagination'
    nextSelector: '.pagination .next a'
    itemSelector: '.grid-item'
    contentSelector: '#images'
    debug: true
    loading:
      finishedMsg: 'No more pages to load.'
      msg: $('<div id="infscr-loading"><i class="icon-spinner icon-spin icon-4x"></i></div>')
  , (newImages, options) ->
    $newImages = $(newImages).css(opacity: 0)
    $newImages.imagesLoaded ->
      $newImages.animate opacity: 1
      $imagesContainer.masonry 'appended', $newImages, true

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
