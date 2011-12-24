class Category
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :title, type: String
  field :description, type: String
  field :previous_slugs, type: Array
  field :legacy_id, type: Integer
  index :legacy_id, unique: true

  slug :title
  references_many :albums, :dependent => :destroy
  references_many :child_categories, :class_name => self.name, :foreign_key => :parent_category_id, :inverse_of => :parent_category
  referenced_in :parent_category, :class_name => self.name, :inverse_of => :child_categories, :index => true

  scope :roots, where(parent_category_id: nil)

  def self.find_by_slug(slug)
    any_of({:slug => slug}, {:previous_slugs.in => slug.to_a}).first
  end

  def thumbnail_url
    if albums.empty? or albums.with_images.empty?
      "/assets/placeholder.png"
    else
      albums.with_images.first.thumbnail_url
    end
  end

  private
  def generate_slug
    push(:previous_slugs, read_attribute(slug_name)) if slugged_fields_changed?
    super
  end
end
