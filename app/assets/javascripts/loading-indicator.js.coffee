App.LoadingIndicator =
  show: ->
    @element().show()

  hide: ->
    @element().hide()

  element: ->
    $('#loading').presence() || $('body').prepend(@html)

  html: "<div id='loading'><div><i class='icon-spinner icon-spin icon-4x'></i></div></div>"
