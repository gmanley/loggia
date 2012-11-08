class Image < ActiveRecord::Base
  attr_accessible :image

  belongs_to :album, counter_cache: true

  mount_uploader :image, ImageUploader

  paginates_per 100

  set_callback(:create, :after) do
    unless album.nil?
      album.self_and_ancestors.each { |a| a.set_thumbnail_url }
    end
  end

  # TODO: Confirm this is still needed.
  skip_callback(:destroy, :after, :remove_image!)
  set_callback(:destroy, :before) { remove_image! }
end
