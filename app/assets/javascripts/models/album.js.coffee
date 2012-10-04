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
    {
      type: 'HasMany'
      key: 'children'
      relatedModel: 'App.Models.Album'
      collectionType: 'App.Collections.AlbumsCollection'
      includeInJSON: false
      reverseRelation:
        key: 'parent'
        includeInJSON: 'id'
    }, {
      type: 'HasMany'
      key: 'comments'
      relatedModel: 'App.Models.Comment'
      collectionType: 'App.Collections.CommentsCollection'
      includeInJSON: false
      reverseRelation:
        key: 'album'
        includeInJSON: 'id'
    }, {
      type: 'HasMany'
      key: 'images'
      relatedModel: 'App.Models.Image'
      collectionType: 'App.Collections.ImagesCollection'
      includeInJSON: false
      reverseRelation:
        key: 'album'
        includeInJSON: 'id'
    }
  ]

  defaults:
    title:         null
    description:   null
    thumbnail_url: '/assets/placeholder.png'

class App.Collections.AlbumsCollection extends Backbone.Collection
  model: App.Models.Album
  url: '/albums'

  roots: ->
    @where(parent_id: null)

  comparator: (category) ->
    category.get('title')
