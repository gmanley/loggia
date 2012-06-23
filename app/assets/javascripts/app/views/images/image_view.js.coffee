App.Views.Images ||= {}

class App.Views.Images.ImageView extends Backbone.View
  template: JST['app/templates/images/_image']
  tagName: 'li'

  destroy: ->
    @model.destroy()
    @remove()

  render: ->
    $(@el).html(@template(@model.toJSON()))
    this