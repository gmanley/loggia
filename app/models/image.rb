class Image
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  embedded_in :album
  mount_uploader :image, ImageUploader
  store_in_background :image if Soshigal::Application.config.store_in_bg

  set_callback(:create, :after) do
    unless album.nil?
      album.inc(:image_count, 1)
      album.ancestors_and_self.each { |a| a.set_thumbnail_url }
    end
  end

  skip_callback(:destroy, :after, :remove_image!)
  set_callback(:destroy, :before) do
    remove_image!
    album.inc(:image_count, -1)
  end
end