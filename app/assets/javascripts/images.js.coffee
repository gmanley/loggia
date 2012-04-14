$ ->
  $('#start_upload').button()
  uploader = new plupload.Uploader(
    runtimes: 'html5,flash'
    browse_button: 'select_files'
    max_file_size: '10mb'
    chunk_size : '1mb',
    url: "#{window.location.pathname}/images.js"
    file_data_name: 'image[image]'
    flash_swf_url: '/assets/plupload.flash.swf'
    drop_element: 'upload_box'
    filters:
      {title: "Image files", extensions: "jpg,gif,png"}
    multipart: true
    multipart_params:
      authenticity_token: authenticity_token
      _soshigal_session: session_token
    )

  uploader.bind "FilesAdded", (up, files) ->
    $.each files, (i, file) ->
      $("#file_list").append("""
        <li id="#{file.id}">
          <div class='file_info'>#{file.name} (#{plupload.formatSize(file.size)}) <b></b></div>
          <div class="progress striped">
            <div class="bar" style="width: 0%;"></div>
          </div>
        </li>
      """)

  uploader.bind 'UploadProgress', (up, file) ->
    $("##{file.id} b").html("#{file.percent}%")
    $("##{file.id} .progress .bar").css('width', "#{file.percent}%")

  $('#start_upload').click (e) ->
    uploader.start()
    $(this).button('loading')
    e.preventDefault()

  uploader.bind 'FileUploaded', (up, file, response) ->
    eval(response.response)
    $("##{file.id} .progress")
      .toggleClass('active')
      .prev('.file_info b').text('Done')
      .fadeOut 'slow', ->
        $(this).parent().css('border', 'none')

  uploader.bind 'UploadComplete', (up, files) ->
    $('#start_upload').button('complete')

  uploader.init()