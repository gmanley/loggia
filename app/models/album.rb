class Album
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :title, type: String
  field :previous_slugs, type: Array

  slug :title

  referenced_in :user
  referenced_in :category
  embeds_many :images

  def self.find_by_slug(slug)
    any_of({:slug => slug}, {:previous_slugs.in => slug.to_a}).first
  end

  def self.with_images
    all.select { |album| album.images.exists? }
  end

  def thumbnail_url
    if images.empty?
      "/assets/placeholder.png"
    else
      images.first.image_url(:thumb)
    end
  end

  private
  def generate_slug
    push(:previous_slugs, read_attribute(slug_name)) if slugged_fields_changed?
    super
  end
end
