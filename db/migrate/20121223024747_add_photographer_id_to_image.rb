class AddPhotographerIdToImage < ActiveRecord::Migration

  def change
    add_column :images, :photographer_id, :integer
    add_index  :images, :photographer_id
  end
end
