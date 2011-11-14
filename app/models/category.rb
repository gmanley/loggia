class Category
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Tree

  field :title

  slug :title
  references_many :albums

  def thumbnail_url
    if albums.empty?
      "/assets/placeholder.png"
    else
      albums.with_images.first.thumbnail_url
    end
  end
end