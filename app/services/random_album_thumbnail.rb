class RandomAlbumThumbnail

  def initialize(album)
    @album = album
  end

  def perform
    if images.empty?
      thumbnail_from_descendants
    else
      thumbnail_from_images
    end
  end

  private
  def random_record(relation)
    RandomRecordQuery.new(relation).perform
  end

  def thumbnail_from_descendants
    unless descendants_with_images.empty?
      record = random_record(descendants_with_images)
      record.thumbnail_url
    end
  end

  def thumbnail_from_images
    record = random_record(images)
    record.image_url(:square)
  end

  def images
    @album.images
  end

  def descendants_with_images
    @album.descendants.with_images
  end
end


