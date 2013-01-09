class AlbumArchiver
  include Sidekiq::Worker

  def perform(album_slug, user_id)
    user = User.find(user_id)
    album = Album.find_by_slug!(album_slug)
    archive = (album.archive || album.create_archive)
    archive.archive_album
    ArchiveMailer.archive_completion(archive, user).deliver
  end
end
