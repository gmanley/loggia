class Archive < ActiveRecord::Base
  attr_accessible :processing

  belongs_to :archivable, polymorphic: true

  mount_uploader :file, ArchiveUploader

  validates_presence_of :archivable

  def archive_album
    return file.url unless outdated?

    update_attributes(processing: true)

    temp_directory = Dir.mktmpdir
    zip_path = File.join(temp_directory, archivable.to_s + '.zip')

    Zip::Archive.open(zip_path, Zip::CREATE) do |zip|
      archivable.sources.each do |source|
        zip.add_dir(source.name)
      end

      images = archivable.images.includes(:source)
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
    update_attributes(processing: false)
    FileUtils.remove_entry_secure(temp_directory) if temp_directory
  end

  def outdated?
    archivable.updated_at > updated_at
  end

  def requesters
    @requesters ||= Redis::List.new("archive_#{id}_requesters")
  end

  private
  def add_image(zip, image_record, parent_path = nil)
    image_file = image_record.image.cached_master
    zip_path = File.join(*[parent_path, image_file.filename].compact)

    zip.add_io(zip_path, image_file.file)
  end
end
