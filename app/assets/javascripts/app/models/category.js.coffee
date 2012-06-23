class App.Models.Category extends Backbone.Model
  paramRoot: 'category'
  routingName: 'categories'

  initialize: (args) ->
    @albums = new App.Collections.AlbumsCollection()
    @albums.category = this

  parse: (response) =>
    unless _.isUndefined(response.children)
      children = _(response.children).groupBy('type')
      @collection.add(children['Category'])
      @albums.add(children['Album'])
    delete response.children
    response

  children: =>
    _.union(@albums.models, @collection.where(parent_id: @id))

class App.Collections.CategoriesCollection extends Backbone.Collection
  model: App.Models.Category
  url: '/categories'
