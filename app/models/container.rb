class Container
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Mongoid::Tree

  field :title,         type: String
  field :description,   type: String
  field :hidden,        type: Boolean, default: false
  field :thumbnail_url, type: String,  default: '/assets/placeholder.png'

  attr_protected :id

  embeds_many :comments, as: :commentable

  index :hidden
  index :title
  index [['comments', Mongo::ASCENDING]]

  validates_presence_of :title

  default_scope asc(:title)

  scope :albums, where(_type: 'Album')
  scope :categories, where(_type: 'Category')

  # FIXME: Kinda hacky since this should belong in the album model
  # but this allows for using this scope in chaining container criteria.
  # There may be a way to do this differently in mongoid 3.
  scope :with_images, excludes(image_count: 0)

  slug :title, :parent do |doc|
    doc.ancestors_and_self.collect(&:title).join(' ')
  end
end
