# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

colorbox_init = ->
  $(".colorbox").colorbox
    maxWidth: "95%"
    maxHeight: "95%"
    rel: 'gallery'
$ ->
  $('#start_upload').button()
  uploader = new plupload.Uploader(
    runtimes: "html5,flash"
    browse_button: "pickfiles"
    max_file_size: "10mb"
    url: "#{window.location.pathname}/images.js"
    file_data_name: 'image[image]'
    flash_swf_url: "/assets/plupload.flash.swf"
    drop_element: 'upload_box'
    multipart: true
    multipart_params:
      "authenticity_token": authenticity_token
      "_soshigal_session": session_token
    )
  uploader.bind "FilesAdded", (up, files) ->
    $.each files, (i, file) ->
      $("#file_list").append "<li id=\"" + file.id + "\">" + "File: " + file.name + " (" + plupload.formatSize(file.size) + ") <b></b>" + "</li>"
  uploader.bind "UploadProgress", (up, file) ->
    $("#" + file.id + " b").html file.percent + "%"
  $("#start_upload").click (e) ->
    uploader.start()
    $(this).button('loading')
    e.preventDefault()
  uploader.bind 'FileUploaded', (up, file, response) ->
    eval(response.response)
    colorbox_init()
  uploader.bind 'UploadComplete', (up, files) ->
    $('#start_upload').button('complete')
  uploader.init()
  colorbox_init()