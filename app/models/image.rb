class Image < ActiveRecord::Base
  belongs_to :album, counter_cache: true
  belongs_to :uploader, class_name: 'User', inverse_of: :uploads
  has_and_belongs_to_many :sources, -> { order(:name).uniq }

  mount_uploader :image, ImageUploader

  paginates_per 20

  validates :md5, on: :create,
                  uniqueness: { scope: :album_id }

  before_validation :set_md5
  after_commit :async_set_thumbnails, on: :create
  before_create :set_store_dir
  after_commit(on: :create) { album.touch(:contents_updated_at) }

  def set_thumbnails
    if album
      album.self_and_ancestors.each { |a| a.set_thumbnail_url }
    end
  end

  def sources_attributes=(attrs)
    attrs.values.each do |source_attrs|
      associate_source(source_attrs)
    end
  end

  def associate_source(attrs)
    if source_id = attrs.delete(:id).presence
      sources << Source.find(source_id)
    else
      unless attrs.values_at(:name, :kind).any?(&:blank?)
        sources << Source.find_or_initialize_by(attrs)
      end
    end
  end

  def album_page_num
    album.images.index(self) / self.class.default_per_page + 1
  end

  private
  def set_md5
    self.md5 = image.md5
  end

  def set_store_dir
    self.store_dir = image.store_dir
  end

  def async_set_thumbnails
    if Rails.env.production?
      Thumbnailer.perform_async(id)
    else
      set_thumbnails
    end
  end
end
