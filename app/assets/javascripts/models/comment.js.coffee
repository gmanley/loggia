class App.Models.Comment extends Backbone.RelationalModel
  paramRoot: 'comment'

class App.Collections.CommentsCollection extends Backbone.Collection
  model: App.Models.Comment
  url: ->
    "/#{@model.slug}/comments"

  comparator: (category) ->
    category.get('created_at')
