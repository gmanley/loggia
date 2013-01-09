# encoding: utf-8

class ArchiveUploader < CarrierWave::Uploader::Base
  include CarrierWave::MimeTypes

  process :set_content_type

  def store_dir
    File.join('uploads', 'archives', model.id.to_s)
  end

  def filename
    "#{model.archivable.display_name}.zip"
  end

  def absolute_url
    "#{asset_host}#{url}"
  end
end
