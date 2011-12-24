class Image
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :album
  mount_uploader :image, ImageUploader do
    def store_dir
      # uploads/images/2009-8/032009-pattaya-international-music-festival-2009/4ef5872ac4b04f25a300317f
      File.join(['uploads', 'images', model.album.category.slug, model.album.slug, model.id.to_s].compact)
    end
  end
end