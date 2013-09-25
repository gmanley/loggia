class MasonrySetup
  defaultOptions:
    itemSelector: '.grid-item.is-shown'
    transitionDuration: '0.3s'
    isFitWidth: true
    gutter: 15

  prepended: =>
    items = @processImgs(@queue.splice(0, @queue.length))
    @masonry.reloadItems()
    @masonry.prepended(items)
    @masonry.reloadItems()

  processImgs: (imgs) ->
    _(imgs).map (img) =>
      $item = @$itemFromImg(img)
      $item.addClass('is-shown')
      $item[0]

  $itemFromImg: (img) ->
    $(img).parents('.grid-item')

  constructor: (args) ->
    @queue = []
    @$container = $(args.container).masonry(
      _(args.options || {}).defaults(@defaultOptions)
    )
    @masonry = @$container.data('masonry')
    throttledPrepended = _.throttle(@prepended, 300, leading: false)
    @$container.imagesLoaded().progress (instance, image) =>
      @queue.push(image.img)
      throttledPrepended()

setupMasonry = ->
  _(['#images', '#albums', '#recent-albums .grid-container']).each (container) ->
    new MasonrySetup(container: container)

# Fixes an issue where masonry images overlap after hitting the back button.
document.addEventListener 'page:restore', ->
  setupMasonry()

$ ->
  setupMasonry()

  $('#clear-images-filter').on 'click', (e) ->
    $('#album_source_ids').val([]).trigger('liszt:updated')
    e.preventDefault()

  $('#filter-images').on('show hide', ->
    $(this).prev().find('.accordian-toggle i')
           .toggleClass('icon-chevron-down')
           .toggleClass('icon-chevron-up')
  ).on('shown', -> $(this).toggleClass('collapse'))
