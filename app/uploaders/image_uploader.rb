# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include CarrierWave::MimeTypes
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper

  EXTENSION_WHITE_LIST = %w(jpg jpeg gif png)

  process :set_content_type

  version :large do
    resize_to_limit(1920, 1080)
  end

  version :thumb, from_version: :large do
    resize_to_fit(285, 500)
  end

  version :square, from_version: :thumb do
    resize_to_fill(285, 285, 'North')
  end

  version :tiny, from_version: :square do
    resize_to_fill(75, 75, 'North')
  end

  def store_dir
    model.store_dir || calculate_store_dir
  end

  def default_url
    image_path('placeholder.png')
  end

  def filename
    @new_filename ||= begin
      if !version_name && conflicting_filename?(super)
        "#{Time.now.to_f}_#{super}"
      else
        super
      end
    end
  end

  def extension_white_list
    EXTENSION_WHITE_LIST
  end

  def md5
    model.md5 || calculate_md5
  end

  def url(options = {})
    URI.encode(URI.decode(super))
  end

  private
  def conflicting_filename?(filename)
    model.album.images.joins(:sources).where(
      image: filename,
      sources: { id: model.sources.map(&:id) }
    ).any?
  end

  def calculate_store_dir
    File.join(*['uploads', 'images',
                model.album.slug,
                model.sources.websites.first.try(:name)].compact)
  end

  def calculate_md5
    Digest::MD5.hexdigest(file.read)
  end
end
