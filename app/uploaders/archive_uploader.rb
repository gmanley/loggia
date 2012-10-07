# encoding: utf-8

class ArchiveUploader < CarrierWave::Uploader::Base
  include CarrierWave::MimeTypes

  process :set_content_type

  def store_dir
    File.join('uploads', 'archives', model.id.to_s)
  end

  def filename
    "#{model.title}.zip"
  end
end
