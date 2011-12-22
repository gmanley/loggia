# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include CarrierWave::MimeTypes
  include Sprockets::Helpers::RailsHelper

  def default_url
    image_path("placeholder.png")
  end

  process :set_content_type

  version :thumb do
    process :resize_to_fill => [200, 200]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
