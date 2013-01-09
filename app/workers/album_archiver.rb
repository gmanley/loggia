class AlbumArchiver
  include Sidekiq::Worker

  def perform(album_slug, user_id)
    album = Album.find_by_slug!(album_slug)
    archive = (album.archive || album.create_archive)
    archive.requesters << user_id

    unless archive.processing?

      if archive.archive_album
        while archive.requesters.count > 0
          ArchiveMailer.archive_completion(archive, archive.requesters.pop).deliver
        end
      end
    end
  end
end
