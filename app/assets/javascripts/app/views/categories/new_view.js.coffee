App.Views.Categories ||= {}

class App.Views.Categories.NewView extends Backbone.View
  template: JST['app/templates/categories/new']

  events:
    'submit #new-category': 'save'

  constructor: (options) ->
    super(options)
    @model = new @collection.model()
    @model.bind('change:errors', => @render())

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.unset('errors')

    @collection.create(@model.toJSON(),
      success: (category) =>
        @model = category
        App.categoriesRouter.navigate("/categories/#{category.id}", trigger: true)

      error: (category, jqXHR) =>
        @model.set(errors: $.parseJSON(jqXHR.responseText))
    )

  render: ->
    @$el.html(@template(@model.toJSON()))
    @$('form').backboneLink(@model)
    this
