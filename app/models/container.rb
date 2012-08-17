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
  has_many :favorites, as: :favoritable

  index hidden: 1
  index title: 1
  index 'comments.created_at' => 1

  validates_presence_of :title

  default_scope asc(:title)

  slug :title

  def favorite_by(user)
    favorites.where(user_id: user.id).first
  end
end