atom_feed do |feed|
  feed.title 'Recently Updated Albums'
  feed.updated @recent_albums.first.updated_at

  @recent_albums.each do |album|
    feed.entry album, published: album.updated_at do |entry|
      entry.title album.display_name
      entry.content image_tag(album.thumbnail_url), type: :html

      entry.author do |author|
        if album.sources.empty?
          author.name 'N/A'
        else
          author.name album.sources.map(&:name).to_sentence
        end
      end
    end
  end
end
