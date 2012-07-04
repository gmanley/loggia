App.Views.Categories ||= {}

class App.Views.Categories.NewView extends Backbone.View
  template: JST['templates/categories/new']

  events:
    'submit #new-category': 'save'

  save: (e) ->
    e.preventDefault()
    unless @form.commit()
      @collection.create(@form.model,
        success: (category) =>
          App.categoriesRouter.navigate("/categories/#{category.id}", trigger: true)
      )

  render: ->
    @$el.html(@template())
    [html, @form] = App.formsetFor('Category', legend: 'New Category')
    @$('#new-category').prepend(html)
    this
