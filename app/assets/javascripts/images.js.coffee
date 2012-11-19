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
  $('#uploader').on('click', '#toggle_deletion.active', (e) ->
    $(this).toggleClass('inactive')
    $('#content').off()
    cleanupDelete()
    $('#delete_instructions').remove()
  )

  $('#uploader').on('click', '#toggle_deletion.inactive', (e) ->
    $(this).toggleClass('inactive')
    $("#content").prepend(JST['templates/delete_instructions'])
    initSelection()
    initConfirmDelete()
  )

  $("form.edit_image").on("ajax:success", (evt, data, status, xhr) ->
    $("#content").prepend(JST['templates/delete_confirmation'])
    $('#delete_confirmation').delay(2000).fadeOut(400)
  )

  uploader = new plupload.Uploader(
    runtimes: 'html5,flash'
    browse_button: 'select_files'
    max_file_size: '10mb'
    url: "#{window.location.pathname}/images.json"
    file_data_name: 'image[image]'
    flash_swf_url: '/assets/plupload.flash.swf'
    drop_element: 'content'
    filters:
      title: 'Image files', extensions: 'jpg,jpeg,gif,png'
    multipart: true
    multipart_params:
      authenticity_token: authenticity_token
      _soshigal_session: session_token
  )

  uploader.bind 'FilesAdded', (up, files) ->
    for file in files
      $('#file_list').append(JST['templates/file'](file: file))

  uploader.bind 'UploadProgress', (up, file) ->
    $("##{file.id} b").html("#{file.percent}%")
    $("##{file.id} .progress .bar").css('width', "#{file.percent}%")

  $('#start_upload').click (e) ->
    uploader.start()
    $(this).button('loading')
    e.preventDefault()

  uploader.bind 'FileUploaded', (up, file, request) ->
    response = JSON.parse(request.response)
    image = JST['templates/image'](image: response.image)
    $imagesContainer.append(image)

    $("##{file.id} .progress")
      .toggleClass('active')
      .prev('.file_info b').text('Done')
      .fadeOut 'slow', ->
        $(this).parent().css('border', 'none')

  uploader.bind 'UploadComplete', (up, files) ->
    $('#start_upload').button('complete')

  uploader.init()
