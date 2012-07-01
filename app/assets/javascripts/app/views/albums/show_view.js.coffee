App.Views.Albums ||= {}

class App.Views.Albums.ShowView extends Backbone.View
  template: JST['app/templates/albums/show']
  fileStatusTemplate: JST['app/templates/images/_file_status']

  events:
    'click #start-upload': 'startUpload'
    'click [data-action=destroy]': 'destroy'

  initialize: ->
    @model.images?.on('add', @addOne)

  addAll: =>
    @model.images.each(@addOne)

  addOne: (image) =>
    return unless image?
    window.image = image
    view = new App.Views.Images.ImageView(model: image)
    @$('.thumbnails').append(view.render().el)

  destroy: ->
    @model.destroy()
    App.albumsRouter.navigate("/albums/#{album.id}", trigger: true)

  render: ->
    @$el.html(@template(album: @model.toJSON()))
    @addAll()
    this

  startUpload: (e) ->
    @uploader.start()
    @$('#start-upload').button('loading')

  initializeUploader: ->
    @$('#start-upload').button()
    @uploader = new plupload.Uploader(
      runtimes: 'html5,flash'
      browse_button: 'select_files'
      max_file_size: '10mb'
      url: "#{@model.url()}/images.json"
      file_data_name: 'image[image]'
      flash_swf_url: '/assets/plupload.flash.swf'
      drop_element: 'content'
      filters: { title: 'Image files', extensions: 'jpg,jpeg,gif,png' }
      multipart_params:
        authenticity_token: authenticity_token
        _soshigal_session: session_token
      )

    @uploader.bind "FilesAdded", (up, files) =>
      for file in files
        $("#file_list").append(@fileStatusTemplate(file))

    @uploader.bind 'UploadProgress', (up, file) ->
      $("##{file.id} b").html("#{file.percent}%")
      $("##{file.id} .progress .bar").css('width', "#{file.percent}%")

    @uploader.bind 'FileUploaded', (up, file, request) =>
      image = JSON.parse(request.response)
      @model.images.add(image)
      @$("##{file.id} .progress")
        .toggleClass('active')
        .prev('.file_info b').text('Done')
        .fadeOut 'slow', ->
          $(this).parent().css('border', 'none')

    @uploader.bind 'UploadComplete', (up, files) ->
      $('#start-upload').button('complete')

    @uploader.init()