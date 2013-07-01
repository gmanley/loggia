class AddForeignKeys < ActiveRecord::Migration

  def change
    add_foreign_key :album_hierarchies, :albums, column: 'ancestor_id'
    add_foreign_key :album_hierarchies, :albums, column: 'descendant_id'
    add_foreign_key :albums, :albums, column: 'parent_id'
    add_foreign_key :comments, :users
    add_foreign_key :favorites, :users
    add_foreign_key :images, :albums
    add_foreign_key :images_sources, :images
    add_foreign_key :images_sources, :sources
    add_foreign_key :images, :users, column: 'uploader_id'
  end
end
