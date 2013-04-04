class Album < ActiveRecord::Base
  attr_accessible :title, :description, :hidden, :parent_id,
                  :archive, :thumbnail_url, :event_date

  has_many :images, order: 'created_at desc',
                    dependent: :destroy

  has_many :comments, as: :commentable,
                      order: 'created_at desc',
                      dependent: :destroy

  has_many :favorites, as: :favoritable,
                       dependent: :destroy

  has_many :sources, through: :images, uniq: true,
                     order: 'LOWER(name)',
                     select: 'sources.*, LOWER(name)'

  has_one :archive, as: :archivable,
                    dependent: :destroy

  acts_as_tree order: :title,
               dependent: :destroy,
               name_column: :title

  validates :title, presence: true,
                    uniqueness: {
                      scope: [:parent_id, :event_date],
                      case_sensitive: false
                    }

  scope :with_images, where(:images_count.not_eq => 0)

  def self.recently_updated(date = 1.month.ago)
    joins(:images).where(
      images: { :created_at.gt => date }
    ).uniq.order('updated_at DESC')
  end

  before_create :set_slug

  def recursive_images
    Image.where(album_id: self_and_descendant_ids)
  end

  def favorite_by(user)
    favorites.where(user_id: user.id).first
  end

  def import_folder(path)
    allowed_exts = ImageUploader::EXTENSION_WHITE_LIST.dup
    allowed_exts.push(*allowed_exts.map(&:upcase))
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
      thumbnail_url = images.offset(rand(images.count)).first.image_url(:square)
    end

    update_attributes(thumbnail_url: thumbnail_url)
  end

  def async_create_archive(user_id)
    AlbumArchiver.perform_async(slug, user_id)
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

  def childless?
    children.empty?
  end

  # TODO: The slug code should really be in a seperate class!
  def slug_components
    slug_replacements = { '.' => '', '/' => ' and ' }

    parent.try(:self_and_ancestors).to_a.reverse.push(self).collect do |album|
      pattern = Regexp.union(slug_replacements.keys)
      album.display_name.gsub(pattern, slug_replacements)
    end
  end

  def generate_slug
    slug_components.join(' ').to_url
  end

  def set_slug
    self.slug = generate_slug
  end
end
