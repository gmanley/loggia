class Container
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Mongoid::Tree

  field :title, type: String
  field :description, type: String
  field :hidden, type: Boolean, default: false
  field :thumbnail_url, type: String, default: '/assets/placeholder.png'

  validates_presence_of :title

  slug :title, :parent do |doc|
    doc.ancestors_and_self.collect(&:title).join(' ')
  end
end
