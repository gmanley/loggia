ALBUM_ARCHIVE_QUEUE = GirlFriday::WorkQueue.new(:album_archive_queue) do |album_id|
  album = Album.find(album_id)
  album.archive!
end