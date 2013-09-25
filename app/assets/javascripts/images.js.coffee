$modalContainer = $('#gallery-modal')

handleSlideChange = (index) ->
  $slide = $('.image a').eq(index)
  imageId = $slide.data('image-id')
  hasher.setHash "images/#{imageId}"

loadSlide = (slide) ->
  options =
    container: $modalContainer.selector
    index: slide
    clearSlides: false
    preloadRange: 10
    continuous: false
    onslide: (index, slide) ->
      handleSlideChange(index)
    onclose: ->
      hasher.setHash ''
      $modalContainer.removeData 'gallery'

  links = $('.image a')
  gallery = new blueimp.Gallery(links, options)

  $modalContainer.data 'gallery', gallery

handleHashChange = (newHash) ->
  if imageId = newHash.match(/images\/(\d+)/)?[1]
    newIndex = $("#image_#{imageId}").index('.image a')
    if gallery = $modalContainer.data('gallery')
      if newIndex != gallery.getIndex()
        gallery.slide(newIndex)
    else
      loadSlide(newIndex)

hasher.changed.add handleHashChange
hasher.initialized.add handleHashChange
hasher.init()

$ ->
  $('#images').on 'click', '.image a', (e) ->
    loadSlide(this)
    e.preventDefault()
