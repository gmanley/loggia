class App.InfiniteScroll
  constructor: (options) ->
    @$container = $(options.container)
    @itemsEl = options.itemsEl || '.grid-item'
    @paginationEl = options.paginationSelector || '.pagination'
    @$paginationEl = $(@paginationEl)
    @nextEl = options.nextEl || "#{@paginationEl} .next a"
    @setup()

  setup: ->
    $.waypoints('destroy')
    if @$paginationEl.exists
      @$paginationEl.hide()
      @$container.waypoint 'infinite',
        items: @itemsEl
        more: @nextEl
        onBeforePageLoad: @beforePageLoad
        onAfterPageLoad: @afterPageLoad

  beforePageLoad: ->
    App.LoadingIndicator.show()

  afterPageLoad: ($newElements) =>
    $newElements.hide().imagesLoaded =>
      $newElements.fadeIn()
      @$container.masonry('appended', $newElements)
      App.LoadingIndicator.hide()
      $.waypoints('refresh')
      $(@$paginationEl).hide()
