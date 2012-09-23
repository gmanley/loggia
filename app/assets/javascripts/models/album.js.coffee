class App.Models.Album extends Backbone.RelationalModel
  urlRoot: '/albums'
  paramRoot: 'album'

  schema:
    title:
      type: 'Text'
      validators: ['required']
    description: 'Text'
    hidden: { type: 'Checkbox', template: 'checkbox' }

  relations: [
    type: 'HasMany'
    key: 'children'
    relatedModel: 'App.Models.Album'
    collectionType: 'App.Collections.AlbumsCollection'
    includeInJSON: false
    reverseRelation:
      key: 'parent'
      includeInJSON: 'id'
  ]

  defaults:
    title:         null
    description:   null
    type:          'Album'
    thumbnail_url: '/assets/placeholder.png'

  initialize: (args) ->
    @images = new App.Collections.ImagesCollection()

  parse: (response) =>
    if response && response.images
      @images.add(response.images)
      delete response.images
    response

class App.Collections.AlbumsCollection extends Backbone.Collection
  model: App.Models.Album
  url: '/albums'

  roots: ->
    @where(parent_id: null)

  comparator: (category) ->
    category.get('title')
