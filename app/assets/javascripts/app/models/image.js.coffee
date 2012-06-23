class App.Models.Image extends Backbone.Model
  paramRoot: 'image'
  routingName: 'images'

class App.Collections.ImagesCollection extends Backbone.Collection
  model: App.Models.Image
  url: '/images'
