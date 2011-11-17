class Album
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :title, type: String

  slug :title

  referenced_in :user
  referenced_in :category
  embeds_many :images

  def thumbnail_url
    if images.empty?
      "/assets/placeholder.png"
    else
      images.first.image_url(:thumb)
    end
  end

  class << self

    def with_images
      all.select { |album| album.images.exists? }
    end
  end
end
