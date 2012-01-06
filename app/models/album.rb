class Album
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :title, type: String
  field :description, type: String
  field :image_count, type: Integer, default: 0
  field :hidden, type: Boolean, default: false
  field :thumbnail_url, type: String

  index :image_count

  slug :title

  referenced_in :user
  referenced_in :category
  embeds_many :images

  scope :with_images, where(:image_count.gt => 0)

  before_save :set_thumbnail_url

  def set_thumbnail_url
    self.thumbnail_url = images.empty? ? '/assets/placeholder.png' : images.sample.image_url(:thumb)
  end
end
