class Album < Container
  embeds_many :images

  field :image_count, type: Integer, default: 0
  index :image_count

  scope :with_images, excludes(image_count: 0)

  def set_thumbnail_url
    update_attribute(:thumbnail_url, images.sample.image_url(:thumb)) unless images.empty?
  end
end
