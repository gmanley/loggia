_.extend App,
  routingNameFor: (type) ->
    if modelClass = App.Models[type]
      modelClass::routingName

  formsetFor: (model, options) ->
    model = new App.Models[model]() if typeof model is 'string'
    form = new Backbone.Form(model: model)
    $el = form.renderFieldset(
      fields: _.keys(model.schema)
      legend: options.legend
    )
    [$el, form]

  handleHistory: ->
    Backbone.history.on 'route', (router, route) ->
      resource_name = router.constructor.name.replace('Router', '').toLowerCase()
      $('body').attr('class', "#{resource_name} #{route}")
    Backbone.history.start()