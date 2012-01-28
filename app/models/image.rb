class Image
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :album
  mount_uploader :image, ImageUploader

  set_callback(:create, :after) do
    album.inc(:image_count, 1) unless album.nil?
  end

  set_callback(:destroy, :after) do
    album.inc(:image_count, -1) unless album.nil?
  end
end