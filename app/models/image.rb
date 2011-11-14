class Image
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :album
  mount_uploader :image, ImageUploader
end
