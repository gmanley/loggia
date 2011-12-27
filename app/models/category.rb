class Category
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :title, type: String
  field :description, type: String

  slug :title

  references_many :albums, dependent: :destroy
  references_many :child_categories, class_name: self.name, foreign_key: :parent_category_id, inverse_of: :parent_category
  referenced_in :parent_category, class_name: self.name, inverse_of: :child_categories, index: true

  scope :roots, where(parent_category_id: nil)

  def thumbnail_url
    if albums.empty? or albums.with_images.empty?
      if child_categories.empty? or child_categories.all? {|c| c.albums.empty? or c.albums.with_images.empty? }
        "/assets/placeholder.png"
      else
        child_categories.select { |cc| cc.albums.with_images.count > 0 }.sample.thumbnail_url
      end
    else
     albums.with_images.sample.thumbnail_url
    end
  end
end
