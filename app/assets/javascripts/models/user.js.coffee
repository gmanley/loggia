class App.Models.User extends Backbone.RelationalModel
  paramRoot: 'user'

  admin: ->
    @get('admin')?
