class Category
  include Mongoid::Document
  include Mongoid::Slug

  field :title

  slug :title
  references_many :albums
  references_many :child_categories, :class_name => self.name, :foreign_key => :parent_category_id, :inverse_of => :parent_category
  referenced_in :parent_category, :class_name => self.name, :inverse_of => :child_categories, :index => true

  scope :roots, where(parent_category_id: nil)

  def thumbnail_url
    if albums.empty?
      "/assets/placeholder.png"
    else
      albums.with_images.first.thumbnail_url
    end
  end
end
