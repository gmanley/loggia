window.tmpl = (id) ->
  if id is 'template-upload'
    return (data) -> JST['templates/file'](data)

initConfirmDelete = ->
  $('#finish_delete').removeAttr('disabled')
  $('#finish_delete').on 'click', (e) ->
    e.preventDefault()
    confirmationMessage = 'This will delete the selected images. Are you sure you want to continue?'
    bootbox.confirm confirmationMessage, (confirmed) ->
      if confirmed then deleteSelected() else cleanupDelete()

    $('#delete_instructions').remove()

initSelection = ->
  $('#content').drag('start', (ev, dd) ->
    $('<div class="selection" />').css('opacity', .65)
                                  .appendTo($('#content'))
  ).drag((ev, dd) ->
    $(dd.proxy).css(
      top: Math.min(ev.pageY, dd.startY)
      left: Math.min(ev.pageX, dd.startX)
      height: Math.abs(ev.pageY - dd.startY)
      width: Math.abs(ev.pageX - dd.startX)
    )
  ).drag 'end', (ev, dd) ->
    $(dd.proxy).remove()

  $('.image').drop('start', ->
    $(this).addClass 'selecting'
  ).drop((ev, dd) ->
    $(this).toggleClass 'selected'
  ).drop 'end', ->
    $(this).removeClass 'selecting'

  $.drop multi: true

cleanupDelete = ->
  $('#finish_delete').attr('disabled', true)
  $('.selected').removeClass('selected')
  $('#images').masonry('reloadItems')

deleteSelected = ->
  $('.selected').each((i, item) ->
    $item = $(item).find('a')
    $.post("/images/#{$item.data('image-id')}", _method: 'delete')
    $item.parent().fadeOut(500).remove()
  )
  cleanupDelete()

albumUrl = ->
  window.location.pathname.replace(/\/page\/\d+/, '')

handleSlideChange = (index) ->
  slide = $('.image a').eq(index)
  imageId = slide.data('image-id')
  app.setLocation("#/images/#{imageId}")

loadSlide = (slide) ->
  options =
    container: $modalContainer[0]
    index: slide
    clearSlides: false
    onslide: (index, slide) ->
      handleSlideChange(index)
    onclose: ->
      app.setLocation("#/")
      $modalContainer.removeData 'gallery'

  links = $('.image a')
  gallery = new blueimp.Gallery(links, options)

  $modalContainer.data 'gallery', gallery

$imagesContainer = $('#images')
$modalContainer = $('#gallery-modal')

$imagesContainer.on 'click', '.image a', (e) ->
  loadSlide(this)
  e.preventDefault()

# initialize the application
window.app = Sammy('#images', ->
  @get '#/', ->
    $modalContainer.data('gallery')?.close()

  @get '#/images/:imageId', ->
    if gallery = $modalContainer.data('gallery')
      newIndex = $("#image_#{@params.imageId}").index('.image a')
      if newIndex != gallery.getIndex()
        gallery.slide(newIndex)
    else
      loadSlide($("#image_#{@params.imageId}"))
)

$ ->
  app.run('#/')

  $('#toggle_selection').click (e) ->
    e.preventDefault()
    if $(this).hasClass('active')
      $('#content').off()
      cleanupDelete()
      $('#delete_instructions').remove()
    else
      $('#content').prepend(JST['templates/delete_instructions'])
      initSelection()
      initConfirmDelete()

  $('#uploader').fileupload(
    url: "#{albumUrl()}/images.json"
    maxFileSize: 20000000
    acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i
    downloadTemplateId: false
    uploadTemplate: (data) ->
      for file in data.files
        JST['templates/file'](file: file, formatFileSize: data.formatFileSize)
    done: (e, data) ->
      $image = $(JST['templates/image'](image: data.result.image, id: data.result.id))
      $image.find('img').load ->
        $imagesContainer.masonry('prepended', $image)
      $imagesContainer.prepend($image)
      data.context.find('.progress').replaceWith("<span class='label label-success'>Success</span>")
    fail: (e, data) ->
      response = JSON.parse(data.xhr().response)
      error = "<td class='error' colspan='2'><span class='label label-important'>Error</span> #{response.errors}</td>"
      data.context.find('.progress').replaceWith(error)
  )
