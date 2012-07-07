class App.Views.Images.ImageView extends Backbone.View
  template: JST['templates/images/_image']
  tagName: 'li'

  destroy: ->
    @model.destroy()
    @remove()

  render: ->
    $(@el).html(@template(@model.toJSON()))
    this