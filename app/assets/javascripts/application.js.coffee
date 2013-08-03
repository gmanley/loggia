#= require libraries
#= require utils
#= require_self
#= require loading-indicator
#= require infinite-scroll
#= require_tree ./templates
#= require albums
#= require comments
#= require images
#= require sources

$ ->
  $('.alert').delay(4000).fadeOut('slow')
  $('.chosen').chosen()
  $('.timeago').timeago()

window.App =
  infinitescrollEnabled: false

# Have a loading screen when turbolinks is working it's magic
document.addEventListener 'page:fetch', ->
  App.LoadingIndicator.show()

document.addEventListener 'page:receive', ->
  App.LoadingIndicator.hide()
