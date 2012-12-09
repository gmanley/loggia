initConfirmDelete = ->
  $delete_button_html = $('<button class="btn btn-danger" id="finish_delete">Complete Deletion</button>')
  $('#toggle_deletion').parent().append($delete_button_html)
  $('#finish_delete').alert()
  $('#finish_delete').on 'click', (e) ->
    $('#delete_instructions').remove()
    $("#content").prepend(JST['templates/delete_warning'])
    $('#yes_delete').on('click', (e) -> deleteSelected())
    $('#no_delete').on('click', (e) -> cleanupDelete())

initSelection = ->
  $('#content').drag("start", (ev, dd) ->
    $('<div class="selection" />').css("opacity", .65)
                                  .appendTo($('#content'))
  ).drag((ev, dd) ->
    $(dd.proxy).css(
      top: Math.min(ev.pageY, dd.startY)
      left: Math.min(ev.pageX, dd.startX)
      height: Math.abs(ev.pageY - dd.startY)
      width: Math.abs(ev.pageX - dd.startX)
    )
  ).drag "end", (ev, dd) ->
    $(dd.proxy).remove()

  $(".thumbnail").drop("start", ->
    $(this).addClass "selecting"
  ).drop((ev, dd) ->
    $(this).toggleClass "selected"
  ).drop "end", ->
    $(this).removeClass "selecting"

  $.drop multi: true

cleanupDelete = ->
  $('#delete_warning').alert('close')
  $('#finish_delete').remove()
  $('.selected').each((i, item) -> $(item).removeClass('selected'))

deleteSelected = ->
  $('.selected').each((i, item) ->
    $item = $(item)
    destroy_url = $item.data('destroy_url') ? $item.attr('href')
    $.post(destroy_url, { _method: 'delete' })
    $item.parent().fadeOut(500).remove()
  )
  cleanupDelete()

$ ->
  $imagesContainer = $('#images')

  $('#start_upload').button()
  $('#toggle_deletion.active').on('click', (e) ->
    $(this).toggleClass('inactive')
    $('#content').off()
    cleanupDelete()
    $('#delete_instructions').remove()
  )

  $('#toggle_deletion.inactive').on('click', (e) ->
    $(this).toggleClass('inactive')
    $("#content").prepend(JST['templates/delete_instructions'])
    initSelection()
    initConfirmDelete()
  )

  $("form.edit_image").on("ajax:success", (evt, data, status, xhr) ->
    $("#content").prepend(JST['templates/delete_confirmation'])
    $('#delete_confirmation').delay(2000).fadeOut(400)
  )

  $uploaderElement = $('#uploader')
  $uploaderElement.fileupload(
    url: "#{window.location.pathname}/images.json"
    maxFileSize: 20000000
    acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i
    downloadTemplateId: false
    done: (e, data) ->
      image = JST['templates/image'](image: data.result.image)
      $('#images').append(image)
      data.context = $(this)
      $uploaderElement.data('fileupload')._trigger('completed', e, data)
    fail: (e, data) ->
      response = JSON.parse(data.xhr().response)
      error = "<td class='error' colspan='2'><span class='label label-important'>Error</span>#{response.errors}</td>"
      $(this).find('.progress').replaceWith(error)
      $uploaderElement.data('fileupload')._trigger('failed', e, data)
  )
