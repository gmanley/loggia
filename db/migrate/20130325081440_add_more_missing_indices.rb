class AddMoreMissingIndices < ActiveRecord::Migration

  def change
    add_index :albums, :updated_at
    add_index :images, :created_at
  end
end
