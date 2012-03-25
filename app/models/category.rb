class Category < Container

  def set_thumbnail_url
    descendants_with_images = descendants.with_images
    unless descendants_with_images.empty?
      thumbnail_url = descendants_with_images.sample.thumbnail_url
      update_attribute(:thumbnail_url, thumbnail_url)
    end
  end
end