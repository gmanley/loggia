$ = jQuery.sub()
Category = App.Category

$.fn.category = ->
  elementID     = $(@).data('id')
  elementID   or= $(@).parents('[data-id]').data('id')
  elementType   = $(@).data('type')
  elementType or= $(@).parents('[data-type]').data('type')

  if elementType == 'Category'
    Category.find(elementID)
  else if elementType == 'Album'
    App.Album.find(elementID)

class New extends Spine.Controller
  events:
    'click [data-action=back]': 'back'
    'submit form': 'submit'

  constructor: ->
    super
    @active @render

  render: ->
    @html @view('categories/new')

  back: ->
    @navigate '/categories'

  submit: (e) ->
    e.preventDefault()
    category = Category.fromForm(e.target).save()
    @navigate '/categories', category.id if category

class Edit extends Spine.Controller
  events:
    'click [data-action=back]': 'back'
    'submit form': 'submit'

  constructor: ->
    super
    @active (params) ->
      @change(params.id)

  change: (id) ->
    @category = Category.find(id)
    @render()

  render: ->
    @html @view('categories/edit')(category: @category)

  back: ->
    @navigate '/categories'

  submit: (e) ->
    e.preventDefault()
    @category.fromForm(e.target).save()
    @navigate '/categories', @category.id

class Show extends Spine.Controller
  events:
    'click [data-action=edit]':    'edit'
    'click [data-action=show]':    'show'
    'click [data-action=destroy]': 'destroy'

  constructor: ->
    super
    @active (params) ->
      @change(params.id)

  change: (id) ->
    @category = Category.find(id)
    @category.ajax().reload(null,success: => @render())

  render: ->
    @html @view('categories/show')(category: @category)

  edit: ->
    @navigate '/categories', @category.id, 'edit'

  destroy: (e) ->
    @category.destroy() if confirm('Are you sure?')
    @navigate '/categories'

  show: (e) ->
    category = $(e.target).category()
    if category.type is 'Category'
      @navigate '/categories', category.id
    else if category.type is 'Album'
      app.append(app.albums = new App.Albums)
      @release(-> app.albums.navigate '/albums', category.id)
      @release()

class Index extends Spine.Controller
  events:
    'click [data-action=show]': 'show'
    'click [data-action=new]':  'new'

  constructor: ->
    super
    Category.bind 'refresh change', @render
    Category.fetch()

  render: =>
    categories = Category.all()
    @html @view('categories/index')(categories: categories)

  show: (e) ->
    category = $(e.target).category()
    @navigate '/categories', category.id

  new: ->
    @navigate '/categories/new'

class App.Categories extends Spine.Stack
  controllers:
    index: Index
    edit:  Edit
    show:  Show
    new:   New

  routes:
    '/categories/new':      'new'
    '/categories/:id/edit': 'edit'
    '/categories/:id':      'show'
    '/categories':          'index'

  default: 'index'
  className: 'stack categories'