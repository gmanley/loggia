class App.Views.Albums.EditView extends Backbone.View
  template: JST['templates/albums/edit']

  events:
    "submit #edit-album" : "update"

  update: (e) ->
    e.preventDefault()
    e.stopPropagation()
    errors = @form.commit()
    unless errors
      if request = @model.save()
        request.done =>
          Backbone.history.navigate("/albums/#{@model.id}", trigger: true)
          App.flashMessage('Album was successfully updated.')

  render: ->
    @$el.html(@template(@model.toJSON()))
    [html, @form] = App.formsetFor(@model, legend: 'Edit Album')
    @$('#edit-album').prepend(html)
    this
