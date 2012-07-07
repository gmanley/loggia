class App.Views.Albums.EditView extends Backbone.View
  template: JST['templates/albums/edit']

  events:
    "submit #edit-album" : "update"

  update: (e) ->
    e.preventDefault()
    e.stopPropagation()
    errors = @form.commit()
    unless errors
      @model.save().done =>
        App.albumsRouter.navigate("/albums/#{@model.id}", trigger: true)

  render: ->
    @$el.html(@template())
    [html, @form] = App.formsetFor(@model, legend: 'Edit Album')
    @$('#edit-album').prepend(html)
    this