class Image
  include Mongoid::Document
  include Mongoid::Timestamps

  field :url
  field :thumb

  embedded_in :album, :inverse_of => :images
  mount_uploader :image, ImageUploader
end
