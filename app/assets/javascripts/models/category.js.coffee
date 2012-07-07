class App.Models.Category extends Backbone.RelationalModel
  paramRoot: 'category'
  routingName: 'categories'

  schema:
    title:
      type: 'Text'
      validators: ['required']
    description: 'Text'
    hidden: { type: 'Checkbox', template: 'checkbox' }

  relations: [
    type: 'HasMany'
    key: 'albums'
    relatedModel: 'App.Models.Album'
    collectionType: 'App.Collections.AlbumsCollection'
    includeInJSON: false
    reverseRelation:
      key: 'category'
      includeInJSON: 'id'
  ,
    type: 'HasMany'
    key: 'categories'
    relatedModel: 'App.Models.Category'
    collectionType: 'App.Collections.CategoriesCollection'
    includeInJSON: false
    reverseRelation:
      key: 'category'
      includeInJSON: 'id'
  ]

  defaults:
    title:         null
    description:   null
    type:          'Category'
    thumbnail_url: '/assets/placeholder.png'

  children: =>
    _.union(@get('categories').models, @get('albums').models)

class App.Collections.CategoriesCollection extends Backbone.Collection
  model: App.Models.Category
  url: '/categories'

  roots: ->
    @where(parent_id: null)

  comparator: (category) ->
    category.get('title')