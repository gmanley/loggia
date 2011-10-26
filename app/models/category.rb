class Category
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Tree

  field :title
  field :thumbnail

  slug :title
  references_many :albums
end