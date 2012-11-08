class CreateAlbums < ActiveRecord::Migration

  def change
    create_table(:albums) do |t|
      t.text    :description
      t.string  :archive
      t.boolean :hidden,        default: false
      t.string  :slug,          null: false
      t.string  :title,         null: false
      t.string  :thumbnail_url, null: false, default: '/assets/placeholder.png'
      t.integer :images_count,  null: false, default: 0
      t.timestamps
    end

    add_index :albums, :slug, unique: true
    add_index :albums, :hidden
    add_index :albums, :images_count
  end
end
