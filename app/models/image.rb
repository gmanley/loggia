class Image
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :album
  mount_uploader :image, ImageUploader

  def after_create(image)
    album.inc(:image_count, 1) unless album.nil?
  end

  def after_destroy(image)
    album.inc(:image_count, -1) unless album.nil?
  end
end