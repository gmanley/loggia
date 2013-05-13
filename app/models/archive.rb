class Archive < ActiveRecord::Base
  attr_accessible :processing

  belongs_to :archivable, polymorphic: true

  mount_uploader :file, ArchiveUploader

  validates_presence_of :archivable

  def archive_album
    return file.url unless outdated?
    file.remove!
    update_attributes(processing: true)

    tmpdir = Dir.mktmpdir
    zip_path = File.join(tmpdir, "#{archivable.to_s}.zip")

    archivable.images.includes(:source).each do |image_record|
      prepare_image(image_record, contents_path)
    end

    Archive::Zip.create(parent_path, zip_path)

    self.file = File.open(zip_path)
    file.url if save
  ensure
    update_attributes(processing: false)
    FileUtils.remove_entry_secure(tmpdir) if tmpdir
  end

  def contents_path
    File.join(
      Rails.public_path, 'archive_contents', archivable.slug, archivable.to_s
    )
  end

  def outdated?
    !file.file.exists? || archivable.last_updated > updated_at
  end

  def requesters
    @requesters ||= Redis::List.new("archive_#{id}_requesters")
  end

  private
  def prepare_image(image_record)
    source_name = image_record.source.try(:name)

    image_file = image_record.image.sanitized_file
    image_path = File.join(*[
      contents_path, source_name, image_file.filename
    ].compact)

    FileUtils.mkdir_p(File.dirname(image_path))
    file.move_to(image_path)
  rescue => e
    Rails.logger.warn(
      "Error archiving #{image_file.filename} to archive #{id}: #{e.inspect}"
    )
  end
end
