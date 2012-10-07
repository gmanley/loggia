class AlbumArchiver
  include Sidekiq::Worker

  def perform(album_id)
    album = Album.find_by_slug!(album_id)
    album.create_archive
  end
end
