# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include CarrierWave::MimeTypes
  include Sprockets::Helpers::RailsHelper

  process :set_content_type

  version :thumb do
    process resize_to_fill: [200, 200]
  end

  def store_dir
    File.join('uploads', 'images', model.id.to_s)
  end

  def default_url
    image_path("placeholder.png")
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
