class MasonrySetup
  defaultOptions:
    itemSelector: '.grid-item.is-shown'
    transitionDuration: '0.3s'
    isFitWidth: true
    gutter: 15

  prepended: =>
    currentBatch = @queue.splice(0, @queue.length)
    items = @processImgs(currentBatch)
    @masonry.reloadItems()
    @masonry.prepended(items)

  processImgs: (imgs) ->
    items = []
    _(imgs).each (img) =>
      $item = @$itemFromImg(img)
      $item.addClass('is-shown')
      items.push($item[0])
    items

  $itemFromImg: (img) ->
    $(img).parents('.grid-item')

  constructor: (args) ->
    @queue = []
    @completed = []
    @container = args.container
    @$container = $(@container).masonry(
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

  $('.datepicker').datepicker(format: 'yyyy.mm.dd')

  $('#clear-images-filter').on 'click', (e) ->
    $('#album_source_ids').val([]).trigger('liszt:updated')
    e.preventDefault()

  $('#filter-images').on('show hide', ->
    $(this).prev().find('.accordian-toggle i')
           .toggleClass('icon-chevron-down')
           .toggleClass('icon-chevron-up')
  ).on('shown', -> $(this).toggleClass('collapse'))
