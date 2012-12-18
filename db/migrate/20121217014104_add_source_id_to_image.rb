class AddSourceIdToImage < ActiveRecord::Migration

  def change
    add_column :images, :source_id, :integer
    add_index  :images, :source_id
  end
end
