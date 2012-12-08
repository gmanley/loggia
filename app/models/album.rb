class Album < ActiveRecord::Base
  attr_accessible :title, :description, :hidden, :parent_id, :archive,
                  :thumbnail_url, :event_date

  has_many :images
  has_many :comments,  as: :commentable, order: :created_at
  has_many :favorites, as: :favoritable

  acts_as_tree order: :title, dependent: :destroy, name_column: :title

  validates :title, presence: true,
                    uniqueness: { scope: [:parent_id, :event_date],
                                  case_sensitive: false }

  scope :with_images, where(:images_count.not_eq => 0)

  mount_uploader :archive, ArchiveUploader

  before_create :set_slug

  def favorite_by(user)
    favorites.where(user_id: user.id).first
  end

  def import_folder(path)
    allowed_exts = ImageUploader::EXTENSION_WHITE_LIST
    glob_pattern = "#{path}/*.{#{allowed_exts.join(',')}}"
    Dir[glob_pattern].each do |file|
      images.create(image: File.open(file))
    end
  end

  def set_thumbnail_url
    if images.empty?
      descendants_with_images = descendants.with_images
      unless descendants_with_images.empty?
        thumbnail_url = descendants_with_images.sample.thumbnail_url
        update_attributes(thumbnail_url: thumbnail_url)
      end
    else
      update_attributes(thumbnail_url: images.sample.image_url(:thumb))
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

  def display_name
    "#{formated_event_date} #{title}".strip
  end
  alias_method :to_s, :display_name

  def formated_event_date
    event_date.strftime('%Y.%m.%d') if event_date
  end

  def to_param
    slug
  end

  # By default closure_tree's ancestry_path will always return an empty array
  # when the record isn't persisted. This overides that behavior to work
  # similarly to how it does when the record is persited.
  def ancestry_path(to_s_column = name_column)
    if persisted?
      super(to_s_column)
    else
      (parent.try(:ancestry_path, to_s_column) || []).push(self[to_s_column])
    end
  end

  private
  def generate_slug
    slug_components = ancestry_path
    slug_components.insert(-2, event_date.strftime('%Y%m%d')) if event_date
    slug_components.join(' ').to_url
  end

  def set_slug
    self.slug = generate_slug
  end
end
