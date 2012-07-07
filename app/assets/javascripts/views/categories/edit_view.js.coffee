class App.Views.Categories.EditView extends Backbone.View
  template: JST['templates/categories/edit']

  events:
    'submit #edit-category': 'update'

  update: (e) ->
    e.preventDefault()
    e.stopPropagation()
    errors = @form.commit()
    unless errors
      if request = @model.save()
        request.done =>
          Backbone.history.navigate("/categories/#{@model.id}", trigger: true)
          App.flashMessage('Category was successfully updated.')

  render: ->
    @$el.html(@template())
    [html, @form] = App.formsetFor(@model, legend: 'Edit Category')
    @$('#edit-category').prepend(html)
    this
