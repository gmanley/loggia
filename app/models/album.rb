class Album < Container
  embeds_many :images
  mount_uploader :archive, ArchiveUploader

  field :image_count, type: Integer, default: 0
  index image_count: 1

  scope :with_images, excludes(image_count: 0)

  def set_thumbnail_url
    unless images.empty?
      update_attribute(:thumbnail_url, images.sample.image_url(:thumb))
    end
  end

  def async_create_archive
    AlbumArchiver.perform_async(id.to_s)
  end

  def create_archive
    zip_temp_file = Tempfile.new(id.to_s, encoding: 'binary')
    Archive::Zip.open(zip_temp_file, :w) do |zip|
      images.each do |image_record|
        image = image_record.image.cached_master
        zip_entry = Archive::Zip::Entry::File.new(image.filename)
        zip_entry.file_data = image.file
        zip << zip_entry
      end
    end

    self.archive = zip_temp_file
    archive.url if save
  ensure
    zip_temp_file.close if zip_temp_file
  end
end