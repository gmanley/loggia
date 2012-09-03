# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::Vips
  include CarrierWave::MimeTypes
  include CarrierWave::Backgrounder::Delay if Soshigal::Application.config.store_in_bg
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper

  EXTENSION_WHITE_LIST = %w(jpg jpeg gif png)

  process :set_content_type

  version :thumb do
    resize_to_fill(200, 200)
  end

  def store_dir
    File.join('uploads', 'images', model.album.slug)
  end

  def filename
    model.id.to_s + File.extname(super.to_s)
  end

  def default_url
    image_path('placeholder.png')
  end

  def extension_white_list
    EXTENSION_WHITE_LIST
  end

  def cached_master
    @cached_master ||= CarrierWave::SanitizedFile.new(
                         tempfile: StringIO.new(file.read),
                         filename: File.basename(path),
                         content_type: file.content_type
                       )
  end
end