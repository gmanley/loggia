class Album
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :title, type: String
  field :description, type: String
  field :previous_slugs, type: Array
  field :image_count, type: Integer, default: 0

  index :image_count

  slug :title

  referenced_in :user
  referenced_in :category
  embeds_many :images

  scope :with_images, where(:image_count.gt => 0)

  def self.find_by_slug(slug)
    any_of({slug: slug}, {:previous_slugs.in => slug.to_a}).first
  end

  def thumbnail_url
    images.empty? ? '/assets/placeholder.png' : images.sample.image_url(:thumb)
  end

  private
  def generate_slug
    push(:previous_slugs, read_attribute(slug_name)) if slugged_fields_changed?
    super
  end
end
