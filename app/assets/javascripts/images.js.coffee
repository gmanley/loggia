$ ->
  $('#start_upload').button()
  uploader = new plupload.Uploader(
    runtimes: 'html5,flash'
    browse_button: 'select_files'
    max_file_size: '10mb'
    url: "#{window.location.pathname}/images.json"
    file_data_name: 'image[image]'
    flash_swf_url: '/assets/plupload.flash.swf'
    drop_element: 'content'
    filters: { title: 'Image files', extensions: 'jpg,jpeg,gif,png' }
    multipart_params:
      authenticity_token: authenticity_token
      _soshigal_session: session_token
    )

  uploader.bind "FilesAdded", (up, files) ->
    $.each files, (i, file) ->
      $("#file_list").append(JST['templates/file'](file: file))

  uploader.bind 'UploadProgress', (up, file) ->
    $("##{file.id} b").html("#{file.percent}%")
    $("##{file.id} .progress .bar").css('width', "#{file.percent}%")

  $('#start_upload').click (e) ->
    uploader.start()
    $(this).button('loading')
    e.preventDefault()

  uploader.bind 'FileUploaded', (up, file, request) ->
    response = JSON.parse(request.response)
    $(".thumbnails").append(JST['templates/image'](image: response.image))
    $("##{file.id} .progress")
      .toggleClass('active')
      .prev('.file_info b').text('Done')
      .fadeOut 'slow', ->
        $(this).parent().css('border', 'none')

  uploader.bind 'UploadComplete', (up, files) ->
    $('#start_upload').button('complete')

  uploader.init()