setupMasonry = ->
  App.LoadingIndicator.show()
  $container = $('.grid-container').masonry
    itemSelector: '.grid-item'
    transitionDuration: '0.5s'
    isFitWidth: true
    gutter: 15
    containerStyle:
      position: 'relative'
      display: 'none'

  $container.imagesLoaded ->
    App.LoadingIndicator.hide()
    $container.show()
    $container.masonry()
    if App.infinitescrollEnabled
      new App.InfiniteScroll
        container: '#images'
        itemsEl: '.image'

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
