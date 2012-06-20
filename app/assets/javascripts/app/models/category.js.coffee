class App.Category extends Spine.Model
  @configure 'Category', 'title', 'description', 'thumbnail_url', 'type'
  @extend Spine.Model.Ajax
  @url: '/categories'

  @hasMany 'albums', 'App.Album'
  @hasMany 'categories', 'App.Category'
  @belongsTo 'category', 'App.Category'

  children: ->
    categories = @categories().all()
    albums = @albums().all()
    categories.concat(albums)

  load: (atts) ->
    unless typeof atts.children is 'undefined'
      for child in atts.children
        switch child.type
          when 'Category'
            relation = @categories()
          when 'Album'
            relation = @albums()
        child_record = relation.model.fromJSON(child)
        child_record.newRecord = false
        child_record[relation.fkey] = atts.id
        relation.model.records[child_record.id] = child_record
    super