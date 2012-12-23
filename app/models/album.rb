class Album < ActiveRecord::Base
  attr_accessible :title, :description, :hidden, :parent_id, :archive,
                  :thumbnail_url, :event_date

  has_many :images

  has_many :comments,  as: :commentable, order: :created_at
  has_many :favorites, as: :favoritable

  has_many :sources,       through: :images, uniq: true
  has_many :photographers, through: :images, uniq: true

  acts_as_tree order: :title, dependent: :destroy, name_column: :title

  validates :title, presence: true,
                    uniqueness: { scope: [:parent_id, :event_date],
                                  case_sensitive: false }

  scope :with_images, where(:images_count.not_eq => 0)

  mount_uploader :archive, ArchiveUploader

  before_create :set_slug

  def recursive_images
    Image.where(album_id: self_and_descendant_ids)
  end

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
        thumbnail_url = descendants_with_images
                        .offset(rand(descendants_with_images.count))
                        .first.thumbnail_url
      end
    else
      thumbnail_url = images.offset(rand(images.count)).first.image_url(:thumb)
    end

    update_attributes(thumbnail_url: thumbnail_url)
  end

  def async_create_archive
    AlbumArchiver.perform_async(id.to_s)
  end

  def create_archive(recursive = false)
    temp_directory = Dir.mktmpdir("album-archive-#{id}")
    zip_path = File.join(temp_directory, display_name + '.zip')

    Zip::Archive.open(zip_path, Zip::CREATE) do |zip|
      # For now limited to immediate children.
      albums = recursive ? children.unshift(self) : [self]

      albums.each do |album|
        zip.add_dir(album.display_name)

        album.images.each do |image_record|
          image_file = image_record.image.cached_master
          zip_path = File.join(album.display_name, image_file.filename)

          zip.add_io(zip_path, image_file.file)
        end
      end
    end

    self.archive = zip_temp_file
    archive.url if save
  ensure
    FileUtils.remove_entry_secure(temp_directory)
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

  private
  def slug_components
    parent.try(:self_and_ancestors).to_a.reverse.push(self).map do |album|
      album.display_name.gsub('.', '')
    end
  end

  def generate_slug
    slug_components.join(' ').to_url
  end

  def set_slug
    self.slug = generate_slug
  end
end
