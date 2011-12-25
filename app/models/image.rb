class Image
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :album
  mount_uploader :image, ImageUploader do
    def store_dir
      File.join(['uploads', 'images', model.album.category.slug, model.album.slug, model.id.to_s].compact)
    end
  end

  def after_create(image)
    album.inc(:image_count, 1) unless album.nil?
  end

  def after_destroy(image)
    album.inc(:image_count, -1) unless album.nil?
  end
end