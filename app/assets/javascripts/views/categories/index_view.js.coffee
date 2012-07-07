class App.Views.Categories.IndexView extends Backbone.View
  template: JST['templates/categories/index']
  el: '#content'

  initialize: ->
    @collection.on('reset', @addAll)

  addAll: =>
    for category in @collection.roots()
      @addOne(category)

  addOne: (category) =>
    view = new App.Views.Containers.ContainerView(model: category)
    @$('.thumbnails').append(view.render().el)

  render: =>
    @$el.html(@template(categories: @collection.toJSON()))
    @addAll()
    this