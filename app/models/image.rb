class Image
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :album
  mount_uploader :image, ImageUploader do
    def store_dir
      File.join(['uploads', 'images', model.album.category.parent_category.slug, model.album.category.slug, model.album.slug, model.id.to_s].compact)
    end
  end
end


