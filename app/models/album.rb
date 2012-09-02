class Album
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Tree

  field :slug,          type: String,  default: -> { generate_slug }
  field :title,         type: String
  field :description,   type: String
  field :hidden,        type: Boolean, default: false
  field :thumbnail_url, type: String,  default: '/assets/placeholder.png'
  field :image_count,   type: Integer, default: 0

  embeds_many :images
  embeds_many :comments, as: :commentable, order: :created_at.desc
  has_many :favorites, as: :favoritable

  index hidden: 1
  index image_count: 1
  index({ slug: 1 }, { unique: true })
  index 'comments.created_at' => 1

  validates :title, presence: true,
                    uniqueness: { scope: :parent_id,
                                  case_sensitive: false }

  default_scope asc(:title)

  scope :with_images, excludes(image_count: 0)

  mount_uploader :archive, ArchiveUploader

  # This lets access slug in controllers via params[:id]
  alias_method :to_param, :slug

  alias_method :to_s, :title

  # Pointless helper?
  def self.find_by_slug!(slug)
    find_by(slug: slug)
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
      descendants_with_images = Album.where(parent_ids: id).with_images
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

  private
  def generate_slug
    ancestors_and_self.collect(&:title).join(' ').to_url
  end

  def update_slug
    update_attribute(:slug, generate_slug)
  end
end