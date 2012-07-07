class App.Views.Categories.NewView extends Backbone.View
  template: JST['templates/categories/new']

  events:
    'submit #new-category': 'save'

  initialize: ->
    @model = new App.Models.Category()

  save: (e) ->
    e.preventDefault()
    unless @form.commit()
      if @collection.create(@model)
        Backbone.history.navigate("/categories/#{@model.id}", trigger: true)
        App.flashMessage('Category was successfully created.')

  render: ->
    @$el.html(@template())
    [html, @form] = App.formsetFor(@model, legend: 'New Category')
    @$('#new-category').prepend(html)
    this
