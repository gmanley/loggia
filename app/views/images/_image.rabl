attribute :id, :image_url
node(:thumbnail_url) { |image| image.image_url(:thumb) }
node(:album_id) { |image| image.album.id }