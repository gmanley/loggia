class Archive < ActiveRecord::Base
  belongs_to :archivable, polymorphic: true

  mount_uploader :file, ArchiveUploader

  validates_presence_of :archivable

  def archive_album
    return file.url unless outdated?
    file.remove!
    update_attributes(processing: true)

    temp_directory = Dir.mktmpdir
    zip_path = File.join(temp_directory, archivable.to_s + '.zip')

    Zip::Archive.open(zip_path, Zip::CREATE) do |zip|
      archivable.sources.each {|source| add_source(zip, source) }

      archivable.images.includes(:source).each do |image_record|
        add_image(zip, image_record, image_record.source.try(:name))
      end
    end

    self.file = File.open(zip_path)
    file.url if save
  ensure
    update_attributes(processing: false)
    FileUtils.remove_entry_secure(temp_directory) if temp_directory
  end

  def outdated?
    !file.file.exists? || archivable.last_updated > updated_at
  end

  def requesters
    @requesters ||= Redis::List.new("archive_#{id}_requesters")
  end

  private
  def add_source(zip, source)
    zip.add_dir(source.name)
  rescue Zip::Error
    Rails.logger.warn("Error adding #{source.name} to archive #{id}.")
  end

  def add_image(zip, image_record, parent_path = nil)
    image_file = image_record.image.cached_master
    zip_path = File.join(*[parent_path, image_file.filename].compact)

    zip.add_io(zip_path, image_file.file)
  rescue Zip::Error
    Rails.logger.warn("Error adding #{image_file.filename} to archive #{id}.")
  end
end
