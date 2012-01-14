class Album
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  belongs_to :category
  embeds_many :images

  field :title, type: String
  field :description, type: String
  field :image_count, type: Integer, default: 0
  field :hidden, type: Boolean, default: false
  field :thumbnail_url, type: String

  index :image_count

  slug :title

  scope :with_images, where(:image_count.gt => 0)

  before_save :set_thumbnail_url

  def set_thumbnail_url
    self.thumbnail_url = images.empty? ? '/assets/placeholder.png' : images.sample.image_url(:thumb)
  end

  def ancestors
    [category, *category.try(:ancestors)]
  end

  def ancestors_and_self
    ancestors.unshift(self)
  end
end
