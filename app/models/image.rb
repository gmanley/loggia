class Image
  include Mongoid::Document
  include Mongoid::Timestamps

  field :url
  field :thumb

  embedded_in :album
  mount_uploader :image, ImageUploader
end
