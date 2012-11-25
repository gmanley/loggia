class Image < ActiveRecord::Base
  attr_accessible :image

  belongs_to :album, counter_cache: true

  mount_uploader :image, ImageUploader

  paginates_per 100

  validates :md5, uniqueness: { scope: :album_id },
                  on: :create

  before_validation :set_md5
  after_create :set_thumbnails
  before_create :set_store_dir

  private
  def set_md5
    self.md5 = image.md5
  end

  def set_store_dir
    self.store_dir = image.store_dir
  end

  def set_thumbnails
    unless album.nil?
      album.self_and_ancestors.each { |a| a.set_thumbnail_url }
    end
  end
end
