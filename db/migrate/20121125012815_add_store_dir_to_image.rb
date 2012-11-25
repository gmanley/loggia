class AddStoreDirToImage < ActiveRecord::Migration

  def change
    add_column :images, :store_dir, :string
  end
end
