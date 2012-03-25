class Category < Container

  def album_descendants
    Album.where(:parent_ids => self.id)
  end

  def set_thumbnail_url
    descendants_with_images = album_descendants.with_images
    unless descendants_with_images.empty?
      thumbnail_url = descendants_with_images.sample.thumbnail_url
      update_attribute(:thumbnail_url, thumbnail_url)
    end
  end
end