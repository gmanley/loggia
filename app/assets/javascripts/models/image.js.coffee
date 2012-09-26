class App.Models.Image extends Backbone.RelationalModel
  paramRoot: 'image'

class App.Collections.ImagesCollection extends Backbone.Collection
  model: App.Models.Image
  url: '/images'

class App.Collections.PaginatedImagesCollection extends Backbone.PaginatedCollection
  model: App.Models.Image
