App.Views.Containers ||= {}

class App.Views.Containers.ContainerView extends Backbone.View
  template: JST['templates/containers/_container']
  tagName: 'li'

  render: ->
    $(@el).html(@template(@model.toJSON()))
    this