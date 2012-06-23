$ = jQuery.sub()
Album = App.Album

$.fn.album = ->
  elementID   = $(@).data('id')
  elementID or= $(@).parents('[data-id]').data('id')
  Album.find(elementID)

class New extends Spine.Controller
  events:
    'click [data-action=back]': 'back'
    'submit form': 'submit'

  constructor: ->
    super
    @active @render

  render: ->
    @html @view('albums/new')

  back: ->
    @navigate '/albums'

  submit: (e) ->
    e.preventDefault()
    album = Album.fromForm(e.target).save()
    @navigate '/albums', album.id if album

class Edit extends Spine.Controller
  events:
    'click [data-action=back]': 'back'
    'submit form': 'submit'

  constructor: ->
    super
    @active (params) ->
      @change(params.id)

  change: (id) ->
    @album = Album.find(id)
    @render()

  render: ->
    @html @view('albums/edit')(album: @album)

  back: ->
    @navigate '/albums'

  submit: (e) ->
    e.preventDefault()
    @album.fromForm(e.target).save()
    @navigate '/albums'

class Show extends Spine.Controller
  events:
    'click [data-action=edit]': 'edit'
    'click [data-action=back]': 'back'

  constructor: ->
    super
    @active (params) ->
      @change(params.id)

  change: (id) ->
    @album = Album.find(id)
    @album.ajax().reload(null, success: => @render())

  render: ->
    @html @view('albums/show')(album: @album)
    $(document.body).on('.modal-gallery.data-api')

  edit: ->
    @navigate '/albums', @album.id, 'edit'

  back: ->
    @navigate '/albums'

class App.Albums extends Spine.Stack
  controllers:
    edit:  Edit
    show:  Show
    new:   New

  routes:
    '/albums/new':      'new'
    '/albums/:id/edit': 'edit'
    '/albums/:id':      'show'

  className: 'stack albums'