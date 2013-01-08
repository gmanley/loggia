class AddUploaderIdToImage < ActiveRecord::Migration

  def change
    add_column :images, :uploader_id, :integer
    add_index  :images, :uploader_id
  end
end
