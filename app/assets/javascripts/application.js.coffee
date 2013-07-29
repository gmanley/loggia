#= require libraries
#= require utils
#= require_tree ./templates
#= require albums
#= require comments
#= require images
#= require sources

$ ->
  $('.alert').delay(4000).fadeOut('slow')
  $('.chosen').chosen()
  $('.timeago').timeago()


window.App = {}

App.LoadingIndicator =
  show: ->
    @element().show()

  hide: ->
    @element().hide()

  element: ->
    $('#loading').presence() || $('body').prepend(@html)

  html: "<div id='loading'><div><i class='icon-spinner icon-spin icon-4x'></i></div></div>"

# Have a loading screen when turbolinks is working it's magic
document.addEventListener 'page:fetch', ->
  App.LoadingIndicator.show()

document.addEventListener 'page:receive', ->
  App.LoadingIndicator.hide()
