class CreateAlbumHierarchies < ActiveRecord::Migration

  def change
    create_table :album_hierarchies, id: false do |t|
      t.integer :ancestor_id,   null: false
      t.integer :descendant_id, null: false
      t.integer :generations,   null: false
    end

    add_index :album_hierarchies, [:ancestor_id, :descendant_id], unique: true
    add_index :album_hierarchies, [:descendant_id]
  end
end
