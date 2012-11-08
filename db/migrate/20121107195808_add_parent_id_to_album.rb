class AddParentIdToAlbum < ActiveRecord::Migration

  def change
    add_column :albums, :parent_id, :integer
  end
end
