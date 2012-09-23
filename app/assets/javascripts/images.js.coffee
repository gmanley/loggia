startSelection = ->
  $(document).drag("start", (ev, dd) ->
    $('<div class="selection" />').css("opacity", .65).appendTo document.body
  ).drag((ev, dd) ->
    $(dd.proxy).css
      top: Math.min(ev.pageY, dd.startY)
      left: Math.min(ev.pageX, dd.startX)
      height: Math.abs(ev.pageY - dd.startY)
      width: Math.abs(ev.pageX - dd.startX)
  ).drag "end", (ev, dd) ->
    $(dd.proxy).remove()

  $(".thumbnail").drop("start", ->
    $(this).addClass "selecting"
  ).drop((ev, dd) ->
    $(this).toggleClass "selected"
  ).drop "end", ->
    $(this).removeClass "selecting"

  $.drop multi: true

cleanup_delete = ->
  $('#start_selection').show()
  $('#finish_delete').remove()
  $('.selected').each(i, item -> $(item).removeClass('selected'))

delete_selected = ->
  $('#delete_warning').alert('close')
  $('.selected').each (i, item) ->
    $item = $(item)
    $.post($item.data('destroy_url'), {_method: 'delete'})
    $item.parent().fadeOut(500)
  cleanup_delete()

$ ->
  $('#start_upload').button()
  $('#toggle_deletion').on 'click', (e) ->
    $(this).hide()
    $instructions_alert_html = $('<div id="delete_instructions" class="alert alert-info fade in">
                                    <a class="close" data-dismiss="alert">×</a>
                                    Click and drag your mouse over the images you wish to delete. Then click "Complete Deletion" (You will be given a chance to cancel).
                                  </div>')

    $("#content").prepend($instructions_alert_html)
    startSelection()

    $delete_button_html = $('<button class="btn btn-danger" id="finish_delete">Complete Deletion</button>')
    $('#start_selection').parent().append($delete_button_html)
    $('#finish_delete').alert()
    $('#finish_delete').on 'click', (e) ->
      $('#delete_instructions').hide()
      $("#content").prepend(JST['templates/delete_warning'])
      $('#yes_delete').on('click', (e) -> delete_selected())
      $('#no_delete').on('click', (e) -> cleanup_delete())

  $("form.edit_image").on("ajax:success", (evt, data, status, xhr) ->
    $response_html = $('<div class="alert alert-info fade in">
                          <a class="close" data-dismiss="alert">×</a>
                          Saved Successfully!
                        </div>')
    $("#content").prepend($response_html)
    $response_html.delay(2000).fadeOut(400)
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
    $('#images').append(JST['templates/image'](image: response.image))
    $("##{file.id} .progress")
      .toggleClass('active')
      .prev('.file_info b').text('Done')
      .fadeOut 'slow', ->
        $(this).parent().css('border', 'none')

  uploader.bind 'UploadComplete', (up, files) ->
    $('#start_upload').button('complete')

  uploader.init()
