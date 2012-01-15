module AlbumHelper

  def breadcrumb_paths
    @album.ancestors_and_self.collect do |e|
      {title: e.title, url: category_album_path(@category, @album)}
    end
  end
end
