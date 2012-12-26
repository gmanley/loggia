class Archive < ActiveRecord::Base

  belongs_to :archivable, polymorphic: true

  mount_uploader :file, ArchiveUploader

  validates_presence_of :archivable

  def add_image(zip, image_record, parent_path = nil)
    image_file = image_record.image.cached_master
    zip_path = File.join(*[parent_path, image_file.filename].compact)

    zip.add_io(zip_path, image_file.file)
  end

  def archive_album
    return file.url unless outdated?

    temp_directory = Dir.mktmpdir("#{archivable_type}-#{archivable.id}-archive-#{id}")
    zip_path = File.join(temp_directory, archivable.to_s + '.zip')

    Zip::Archive.open(zip_path, Zip::CREATE) do |zip|
      images = archivable.images.includes(:source)
      images.map(&:source).uniq.compact.each do |source|
        zip.add_dir(source.name)
      end

      images.each do |image_record|
        if source = image_record.source
          add_image(zip, image_record, source.name)
        else
          add_image(zip, image_record)
        end
      end
    end

    self.file = File.open(zip_path)
    file.url if save
  ensure
    FileUtils.remove_entry_secure(temp_directory) if temp_directory
  end
end
