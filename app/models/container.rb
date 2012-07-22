class Container
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Mongoid::Tree

  field :title,         type: String
  field :description,   type: String
  field :hidden,        type: Boolean, default: false
  field :thumbnail_url, type: String,  default: '/assets/placeholder.png'

  embeds_many :comments, as: :commentable, order: :created_at.desc

  index :hidden
  index :title
  index [['comments.created_at', Mongo::DESCENDING]]

  validates_presence_of :title

  default_scope asc(:title)

  slug :title, :parent do |doc|
    doc.ancestors_and_self.collect(&:title).join(' ')
  end
end