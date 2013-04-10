class AddContentsUpdatedAtToAlbums < ActiveRecord::Migration

  def change
    add_column :albums, :contents_updated_at, :timestamp
    add_index :albums, :contents_updated_at
    remove_index :albums, :updated_at
  end
end
