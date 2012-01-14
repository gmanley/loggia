class Category
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Mongoid::Tree

  has_many :albums, dependent: :destroy

  field :title, type: String
  field :description, type: String
  field :hidden, type: Boolean, default: false
  field :thumbnail_url, type: String

  slug :title

  before_save :set_thumbnail_url

  def set_thumbnail_url
    if albums.empty? or albums.with_images.empty?
      if children.all? {|c| c.albums.empty? or c.albums.with_images.empty? }
        self.thumbnail_url = '/assets/placeholder.png'
      else
        self.thumbnail_url = children.select { |cc| cc.albums.with_images.count > 0 }.sample.thumbnail_url
      end
    else
     self.thumbnail_url = albums.with_images.sample.thumbnail_url
    end
  end
end