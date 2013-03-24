class CreateImagesSourcesJoinTable < ActiveRecord::Migration

  def change
    create_table(:images_sources, id: false) do |t|
      t.references :image
      t.references :source
    end

    add_index :images_sources, [:image_id, :source_id], unique: true
  end
end
