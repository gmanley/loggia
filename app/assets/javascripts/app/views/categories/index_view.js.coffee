App.Views.Categories ||= {}

class App.Views.Categories.IndexView extends Backbone.View
  template: JST["app/templates/categories/index"]
  el: '#content'

  initialize: ->
    @options.categories.on('reset', @addAll)

  addAll: =>
    @options.categories.each(@addOne)

  addOne: (category) =>
    view = new App.Views.Categories.CategoryView(model: category)
    @$('.thumbnails').append(view.render().el)

  render: =>
    @$el.html(@template(categories: @options.categories.toJSON()))
    @addAll()
    this