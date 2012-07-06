class App.Models.Album extends Backbone.RelationalModel
  urlRoot: '/albums'
  paramRoot: 'album'
  routingName: 'albums'

  schema:
    title:
      type: 'Text'
      validators: ['required']
    description: 'Text'
    hidden: { type: 'Checkbox', template: 'checkbox' }

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

  comparator: (category) ->
    category.get('title')