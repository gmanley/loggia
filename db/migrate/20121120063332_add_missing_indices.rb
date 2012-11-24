class AddMissingIndexes < ActiveRecord::Migration

  def change
    add_index :albums, :parent_id

    add_index :comments, [:commentable_id, :commentable_type]
    add_index :comments, :user_id

    add_index :favorites, [:favoritable_id, :favoritable_type]
    add_index :favorites, :user_id

    add_index :images, :album_id
    add_index :images, :md5
  end
end
