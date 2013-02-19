# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include CarrierWave::MimeTypes
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper

  EXTENSION_WHITE_LIST = %w(jpg jpeg gif png)

  process :set_content_type

  version :thumb do
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
      if conflicting_filename?(super)
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

  def cached_master
    @cached_master ||= CarrierWave::SanitizedFile.new(
      tempfile: StringIO.new(file.read),
      filename: File.basename(path),
      content_type: file.content_type
    )
  end

  private
  def conflicting_filename?(filename)
    model.album.images.where(
      image: filename,
      source_id: model.source.try(:id)
    ).any?
  end

  def calculate_store_dir
    File.join(*['uploads', 'images',
                model.album.slug, model.source.try(:name)].compact)
  end

  def calculate_md5
    Digest::MD5.hexdigest(file.read)
  end
end
