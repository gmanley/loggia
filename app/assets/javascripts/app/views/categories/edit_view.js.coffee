App.Views.Categories ||= {}

class App.Views.Categories.EditView extends Backbone.View
  template: JST["app/templates/categories/edit"]

  events:
    "submit #edit-category" : "update"

  update: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.save(null,
      success: (category) =>
        @model = category
        App.categoriesRouter.navigate("/categories/#{category.id}", trigger: true)
    )

  render: ->
    @$el.html(@template(@model.toJSON()))
    @$('form').backboneLink(@model)
    this
