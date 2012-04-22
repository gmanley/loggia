class AlbumArchiver
  include Sidekiq::Worker

  def perform(album_id)
    album = Album.find(album_id)
    album.create_archive
  end
end