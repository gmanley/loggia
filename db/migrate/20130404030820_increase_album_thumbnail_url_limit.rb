class IncreaseAlbumThumbnailUrlLimit < ActiveRecord::Migration

  def up
    change_column :albums, :thumbnail_url, :string, limit: 400
  end

  def down
    change_column :albums, :thumbnail_url, :string, limit: 255
  end
end
