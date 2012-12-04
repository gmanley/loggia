module Mongo
  class Import
    APPLICABLE_ATTRIBUTES = %w(description hidden thumbnail_url title)

    def initialize(file)
      @albums_json = JSON(File.read(File.expand_path(file)))
      @albums = []
    end

    def start
      binding.pry
      @albums_json.each do |album_attributes|
        @albums << import_album(album_attributes)
      end

      @albums.each do |album|
        if legacy_parent_id = album.legacy_parent_id
          parent = @albums.find { |album| album.legacy_id == legacy_parent_id }
          album.parent = parent
        end

        album.save
      end
    end

    def import_album(attributes)
      album = Album.new(attributes.extract!(*APPLICABLE_ATTRIBUTES))
      album.legacy_id = attributes['_id']['$oid']
      album.legacy_parent_id = attributes['parent_id'].try('[]', '$oid')

      if images_json = attributes['images']

        images = []
        images_json.each do |image_attributes|
          images << import_image(image_attributes)
        end

        album.images = images
      end

      album
    end

    def import_image(attributes)
      Image.reset_callbacks(:validation)
      Image.reset_callbacks(:create)
      legacy_id = attributes['_id']['$oid']
      image = Image.new(attributes.extract!('image'))
      image.store_dir = File.join('uploads', 'images', legacy_id)
      image.save(validate: false)
      image
    end
  end
end
