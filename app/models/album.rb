class Album
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :title, type: String
  field :description, type: String
  field :image_count, type: Integer, default: 0

  index :image_count

  slug :title

  referenced_in :user
  referenced_in :category
  embeds_many :images

  scope :with_images, where(:image_count.gt => 0)

  def thumbnail_url
    images.empty? ? '/assets/placeholder.png' : images.sample.image_url(:thumb)
  end
end
