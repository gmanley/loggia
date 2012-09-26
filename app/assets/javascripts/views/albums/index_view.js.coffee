class App.Views.Albums.IndexView extends Backbone.Marionette.CompositeView
  itemView: App.Views.Albums.AlbumView
  template: 'templates/albums/index'
  el: '#content'
  itemViewContainer: '#albums'
