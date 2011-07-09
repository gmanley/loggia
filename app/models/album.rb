class Album
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :title

  slug :title
  referenced_in :user
  embeds_many :photos
end