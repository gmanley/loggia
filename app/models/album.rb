class Album < Container
  embeds_many :images
  mount_uploader :archive, ArchiveUploader

  field :image_count, type: Integer, default: 0
  index :image_count

  scope :with_images, excludes(image_count: 0)

  def set_thumbnail_url
    update_attribute(:thumbnail_url, images.sample.image_url(:thumb)) unless images.empty?
  end

  def add_to_archive_queue!
    ALBUM_ARCHIVE_QUEUE.push(id.to_s)
  end

  def archive!
    zip_temp_file = Tempfile.new(id.to_s, encoding: 'binary')
    Archive::Zip.open(zip_temp_file, :w) do |zip|
      images.each do |image_record|
        image = image_record.image

        image.class.enable_processing = false
        image.cache_stored_file! unless image.cached?
        image.class.enable_processing = true

        image_path = Rails.root.join('public', image.cache_dir, image.cache_name)
        zip << Archive::Zip::Entry.from_file(image_path)
      end
    end

    self.archive = zip_temp_file
    archive.url if save
  ensure
    zip_temp_file.close if zip_temp_file
  end
end