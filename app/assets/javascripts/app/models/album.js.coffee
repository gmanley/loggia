class App.Album extends Spine.Model
  @configure 'Album', 'title', 'description'
  @extend Spine.Model.Ajax

  @hasMany 'images', 'App.Image'

  load: (atts) ->
    unless typeof atts.images is 'undefined'
      for image in atts.images
        image_record = @images().model.fromJSON(image)
        image_record.newRecord = false
        image_record[@images().fkey] = atts.id
        @images().model.records[image_record.id] = image_record
    super