class App.Image extends Spine.Model
  @configure 'Image', 'image_url', 'thumbnail_url', 'id', 'album_id'
  @extend Spine.Model.Ajax
  @url: ->
   "#{@album_id}/images"

  @belongsTo 'album', 'App.Album'